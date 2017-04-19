//
//  BLTDFUHelper.m
//  ZKKBLT_OTA
//
//  Created by zorro on 15/2/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTDFUHelper.h"
#import "ViewController.h"

@implementation BLTDFUHelper

DEF_SINGLETON(BLTDFUHelper)

- (void)setControlPointChar:(CBCharacteristic *)controlPointChar
{
    if (controlPointChar != _controlPointChar)
    {
        _controlPointChar = controlPointChar;
        _isFoundControlPointChar = YES;
        [self checkAllCharacteristicIsExist];
    }
}

- (void)setPacketChar:(CBCharacteristic *)packetChar
{
    if (packetChar != _packetChar)
    {
        _packetChar = packetChar;
        _isFoundPacketChar = YES;
        [self checkAllCharacteristicIsExist];
    }
}

- (void)setVersionChar:(CBCharacteristic *)versionChar
{
    if (versionChar != _versionChar)
    {
        _versionChar = versionChar;
        _isFoundVersionChar = YES;
        [self checkAllCharacteristicIsExist];
    }
}

- (void)checkAllCharacteristicIsExist
{
    if (_isFoundControlPointChar && _isFoundPacketChar && _isFoundVersionChar)
    {
        [self performDFUOnFileWithMetaData];
    }
}

-(void)performDFUOnFileWithMetaData
{
    NSArray *array = [Utility getUpdateFirmWarePath];
    
    _firmwareFileMetaData = array[1];
    [self initParameters];
    [self openFile:array[0]];
    [self startDFU:APPLICATION];
    [self writeFileSize:(uint32_t)_binFileSize];
    
    if (_isFoundVersionChar)
    {
        [_updatePeripheral readValueForCharacteristic:_versionChar];
    }
}

- (void)initParameters
{
    _startTime = [NSDate date];
    _binFileSize = 0;
}

- (void)openFile:(NSURL *)fileURL
{
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
    if (fileData.length > 0)
    {
        [self processFileData:fileURL];
    }
    else
    {
        NSLog(@"Error: file is empty!");
        
        if (_endBlock)
        {
            _endBlock(NO);
        }
        
        if (_updateBlock)
        {
            _updateBlock(BLTDFUHelperUpdateNoUpdateFile, 0);
        }
    }
}

- (void)processFileData:(NSURL *)fileURL
{
    NSString *fileName = [[fileURL path] lastPathComponent];
    //lastPathComponent,获取文件路径并且带后缀名
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
    if ([Utility isFileExtension:fileName fileExtension:HEX])
    {
        _binFileData = [IntelHex2BinConverter convert:fileData];
        // NSLog(@"HexFileSize: %lu and BinFileSize: %lu",(unsigned long)fileData.length,(unsigned long)self.binFileData.length);
    }
    else if ([Utility isFileExtension:fileName fileExtension:BIN])
    {
        _binFileData = [NSData dataWithContentsOfURL:fileURL];
        // NSLog(@"BinFileSize: %lu",(unsigned long)self.binFileData.length);
    }
    
    _numberOfPackets = ceil((double)self.binFileData.length / (double)PACKET_SIZE);
    _bytesInLastPacket = (self.binFileData.length % PACKET_SIZE);
    if (_bytesInLastPacket == 0)
    {
        self.bytesInLastPacket = PACKET_SIZE;
    }
    
    // NSLog(@"Number of Packets %d Bytes in last Packet %d",self.numberOfPackets,self.bytesInLastPacket);
    _writingPacketNumber = 0;
    _binFileSize = _binFileData.length;
}

- (void)startDFU:(DfuFirmwareTypes)firmwareType
{
    uint8_t value[] = {START_DFU_REQUEST, firmwareType};
    
    [_updatePeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
}

- (void)writeFileSize:(uint32_t)firmwareSize
{
    uint32_t fileSizeCollection[3];
    
    fileSizeCollection[0] = 0;
    fileSizeCollection[1] = 0;
    fileSizeCollection[2] = firmwareSize;
    
    [_updatePeripheral writeValue:[NSData dataWithBytes:&fileSizeCollection length:sizeof(fileSizeCollection)]
                forCharacteristic:_packetChar
                             type:CBCharacteristicWriteWithoutResponse];
}


-(void)processDFUResponse:(uint8_t *)data
{
    // NSLog(@"processDFUResponse");
    [self setDFUResponseStruct:data];
    if (_dfuResponse.responseCode == RESPONSE_CODE)
    {
        [self processRequestedCode];
    }
    else if(_dfuResponse.responseCode == PACKET_RECEIPT_NOTIFICATION_RESPONSE)
    {
        [self processPacketNotification];
    }
}

- (void)setDFUResponseStruct:(uint8_t *)data
{
    _dfuResponse.responseCode = data[0];
    _dfuResponse.requestedCode = data[1];
    _dfuResponse.responseStatus = data[2];
}

- (void)processRequestedCode
{
    switch (_dfuResponse.requestedCode)
    {
        case START_DFU_REQUEST:
            [self processStartDFUResponseStatus];
            break;
        case RECEIVE_FIRMWARE_IMAGE_REQUEST:
            NSLog(@"Requested code is Receive Firmware Image now processing response status");

            [self processReceiveFirmwareResponseStatus];
            break;
        case VALIDATE_FIRMWARE_REQUEST:
            NSLog(@"Requested code is Validate Firmware now processing response status");

            [self processValidateFirmwareResponseStatus];
            break;
        case INITIALIZE_DFU_PARAMETERS_REQUEST:
            [self processInitPacketResponseStatus];
            break;
        default:
            break;
    }
}

- (void)processStartDFUResponseStatus
{
    switch (_dfuResponse.responseStatus)
    {
        case OPERATION_SUCCESSFUL_RESPONSE:
            if (_isFoundVersionChar)
            {
                [self sendInitPacket:self.firmwareFileMetaData];
            }
            else {
                [self startSendingFile];
            }
            break;
        case OPERATION_NOT_SUPPORTED_RESPONSE:
            [self resetSystem];
            break;
        default:
            [self resetSystem];
            break;
    }
}

//Init Packet is included in new DFU in SDK 7.0
- (void)sendInitPacket:(NSURL *)metaDataURL
{
    NSData *fileData = [NSData dataWithContentsOfURL:metaDataURL];
    // NSLog(@"metaDataFile length: %lu..%@",(unsigned long)[fileData length], fileData);
    //send initPacket with parameter value set to Receive Init Packet [0] to dfu Control Point Characteristic
    
    uint8_t initPacketStart[] = {INITIALIZE_DFU_PARAMETERS_REQUEST, START_INIT_PACKET};
    [_updatePeripheral writeValue:[NSData dataWithBytes:&initPacketStart length:sizeof(initPacketStart)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
    
    //send init Packet data to dfu Packet Characteristic
    [_updatePeripheral writeValue:fileData
                forCharacteristic:_packetChar
                             type:CBCharacteristicWriteWithoutResponse];
    
    //send initPacket with parameter value set to Init Packet Complete [1] to dfu Control Point Characteristic
    uint8_t initPacketEnd[] = {INITIALIZE_DFU_PARAMETERS_REQUEST, END_INIT_PACKET};
    [_updatePeripheral writeValue:[NSData dataWithBytes:&initPacketEnd length:sizeof(initPacketEnd)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
}


- (void)startSendingFile
{
    [self enablePacketNotification];
    [self receiveFirmwareImage];
    [self writeNextPacket];
    
    // 通知主界面开始发送数据了..
}

- (void)enablePacketNotification
{
    // NSLog(@"DFUOperationsdetails enablePacketNotification");
    uint8_t value[] = {PACKET_RECEIPT_NOTIFICATION_REQUEST, PACKETS_NOTIFICATION_INTERVAL,0};
    [_updatePeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
}

- (void)receiveFirmwareImage
{
    // NSLog(@"DFUOperationsdetails receiveFirmwareImage");
    uint8_t value = RECEIVE_FIRMWARE_IMAGE_REQUEST;
    [_updatePeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
}

- (void)writeNextPacket
{
    int percentage = 0;
    for (int index = 0; index < PACKETS_NOTIFICATION_INTERVAL; index++)
    {
        if (_writingPacketNumber > _numberOfPackets - 2)
        {
            NSRange dataRange = NSMakeRange(_writingPacketNumber * PACKET_SIZE, _bytesInLastPacket);
            NSData *nextPacketData = [_binFileData subdataWithRange:dataRange];
            [_updatePeripheral writeValue:nextPacketData
                        forCharacteristic:_packetChar
                                     type:CBCharacteristicWriteWithoutResponse];
            _writingPacketNumber++;
            
            break;
        }
        
        NSRange dataRange = NSMakeRange(_writingPacketNumber * PACKET_SIZE, PACKET_SIZE);
        NSData *nextPacketData = [_binFileData subdataWithRange:dataRange];
        //NSLog(@"writing packet number %d ...",self.writingPacketNumber+1);
        //NSLog(@"packet data: %@",nextPacketData);
        [_updatePeripheral writeValue:nextPacketData
                    forCharacteristic:_packetChar
                                 type:CBCharacteristicWriteWithoutResponse];
        percentage = (((double)(_writingPacketNumber * 20) / (double)(_binFileSize)) * 100);
       
        self.writingPacketNumber++;
    }
    
    // 通知界面更新百分比..
    NSLog(@"..%d", percentage);
    
    if (_updateBlock)
    {
        _updateBlock(BLTDFUHelperUpdateing, percentage);
    }
}

- (void)processReceiveFirmwareResponseStatus
{
    if (_dfuResponse.responseStatus == OPERATION_SUCCESSFUL_RESPONSE)
    {
        [self validateFirmware];
    }
    else
    {
        [self resetSystem];
    }
}

- (void)validateFirmware
{
    NSLog(@"DFUOperationsdetails validateFirmwareImage");
    uint8_t value = VALIDATE_FIRMWARE_REQUEST;
    [_updatePeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
}

- (void)processValidateFirmwareResponseStatus
{
    if (_dfuResponse.responseStatus == OPERATION_SUCCESSFUL_RESPONSE)
    {
        NSLog(@"..成功后重置系统");
        [self activateAndReset];
        [self calculateDFUTime];
        
        // 通知界面 成功结束.
    }
    else
    {
        [self resetSystem];
    }
}

- (void)activateAndReset
{
    uint8_t value = ACTIVATE_AND_RESET_REQUEST;
    [_updatePeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
}

- (void)calculateDFUTime
{
    _finishTime = [NSDate date];
    _uploadTimeInSeconds = [_finishTime timeIntervalSinceDate:_startTime];
    NSLog(@"upload time in sec: %lu",(unsigned long)_uploadTimeInSeconds);
    
    _isFoundControlPointChar = NO;
    _isFoundPacketChar = NO;
    _isFoundVersionChar = NO;
    
    if (_endBlock)
    {
        _endBlock(YES);
    }
    
    if (_updateBlock)
    {
        _updateBlock(BLTDFUHelperUpdateSuccess, 0);
    }
}

- (void)processInitPacketResponseStatus
{
    if(_dfuResponse.responseStatus == OPERATION_SUCCESSFUL_RESPONSE)
    {
        [self startSendingFile];
    }
    else
    {
        [self resetSystem];
    }
}

- (void)processPacketNotification
{
    if (_writingPacketNumber < _numberOfPackets)
    {
        [self writeNextPacket];
    }
}

// 重启系统.
- (void)resetSystem
{
    uint8_t value = RESET_SYSTEM;
    [_updatePeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)]
                forCharacteristic:_controlPointChar
                             type:CBCharacteristicWriteWithResponse];
    
    _isFoundControlPointChar = NO;
    _isFoundPacketChar = NO;
    _isFoundVersionChar = NO;
    
    if (_endBlock)
    {
        _endBlock(NO);
    }
    
    if (_updateBlock)
    {
        _updateBlock(BLTDFUHelperUpdateFail, 0);
    }
}

- (void)onReadDfuVersion:(NSInteger)version
{
    if (version == 0)
    {
        [self resetSystem];
    }
    else
    {
        if (version == 1)
        {
            [self startDFU:APPLICATION];
        }
    }
}

@end
