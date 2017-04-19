//
//  BLTModel.m
//  ProductionTest
//
//  Created by zorro on 15-1-16.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "BLTModel.h"
#import "AlarmClockModel.h"
#import "RemindModel.h"

@implementation BLTModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _bltName = @"";
        _bltUUID = @"";
        _bltVersion = 0;
        _bltOnlineVersion = 0;
        _bltRSSI = @"";
        
        _isDialingRemind = NO;
        _delayDialing = 8; // 默认8秒.
        
        _isLostModel = NO;
        
        /*
        _lostmName = @"Alarm.mp3";
        _findName = @"Alarm.mp3";
        _lostVolume = 1.0;
        _findVolume = 1.0;
        
        _isOpenFindLED = YES;
        _isOpenLost = YES;
        _isOpenLostLED = YES;
        _distanceType = BLTModelLostDistancenNear;
         */
    }
    
    return self;
}

+ (void)initialize
{
    [self removePropertyWithColumnName:@"peripheral"];
    [self removePropertyWithColumnName:@"alarmArray"];
    [self removePropertyWithColumnName:@"remindArray"];
    [self removePropertyWithColumnName:@"bltRSSI"];
    [self removePropertyWithColumnName:@"bltVersion"];
    [self removePropertyWithColumnName:@"bltOnlineVersion"];
    [self removePropertyWithColumnName:@"bltElec"];
    [self removePropertyWithColumnName:@"isConnected"];
    [self removePropertyWithColumnName:@"isRepeatConnect"];
    [self removePropertyWithColumnName:@"isInitiative"];
    [self removePropertyWithColumnName:@"bltNickName"];
}

+ (instancetype)initWithUUID:(NSString *)uuid
{
    BLTModel *model = [[BLTModel alloc] init];
    
    model.bltUUID = uuid;

    return model;
}

+ (BLTModel *)getModelFromDBWtihUUID:(NSString *)uuid
{
    // 避免数据库的循环使用.
    [ShareData sharedInstance].isAllowBLTSave = NO;

    NSString *where = [NSString stringWithFormat:@"bltUUID = '%@'", uuid];
    BLTModel *model = [BLTModel searchSingleWithWhere:where orderBy:nil];

    if (!model)
    {
        model = [BLTModel initWithUUID:uuid];
        
        [model saveToDB];
    }
    
    [model setAlarmArrayAndRemindArrayWithUUID:uuid];
    
    [ShareData sharedInstance].isAllowBLTSave = YES;

    return model;
}

- (void)setAlarmArrayAndRemindArrayWithUUID:(NSString *)uuid
{
    _alarmArray = [AlarmClockModel getAlarmClockFromDBWithUUID:uuid];
    _remindArray = [RemindModel getRemindFromDBWithUUID:uuid];
    _drinkModel = [DrinkModel getDrinkFromDBWithUUID:uuid];
}

// 闹钟重新排序.
- (NSArray *)alarmArray
{
    if (_alarmArray.count > 1)
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_alarmArray];
        
        [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            AlarmClockModel *model1 = (AlarmClockModel *)obj1;
            AlarmClockModel *model2 = (AlarmClockModel *)obj2;
            
            if (((model1.hour * 60 + model1.minutes) * 100 + model1.orderIndex) >
                ((model2.hour * 60 + model2.minutes) * 100 + model2.orderIndex))
            {
                return NSOrderedAscending;
            }
            else
            {
                return NSOrderedDescending;
            }
        }];
        
        _alarmArray =  array;
    }
    
    return _alarmArray;
}

// 这个方法要弃用...影响指针的操作.
// 添加闹钟. height 为cell的高度.
- (BOOL)addAlarmClock:(CGFloat)height
{
    for (int i = 0; i < _alarmArray.count; i++)
    {
        AlarmClockModel *model = _alarmArray[i];
        
        if (model.showHeight < 20.0)
        {
            model.showHeight = height;
            
            return YES;
        }
    }
    
    return NO;
}

// 主建
+ (NSString *)getPrimaryKey
{
    return @"bltUUID";
}

// 表名
+ (NSString *)getTableName
{
    return @"BLTModel";
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

- (NSString *)imageForsignalStrength
{
    NSInteger rssi = [_bltRSSI integerValue];
    
    if (rssi < 55)
    {
        return @"signal_4_5.png";
    }
    else if (rssi < 80)
    {
        return @"signal_3_5.png";
    }
    else if (rssi < 110)
    {
        return @"signal_2_5.png";
    }
    else
    {
        return @"signal_1_5.png";
    }
}

// 更新当前模型到数据库.
- (void)updateCurrentModelToDB
{
    if ([ShareData sharedInstance].isAllowBLTSave)
    {
        [BLTModel updateToDB:self where:nil];
    }
}

- (BOOL)isConnected
{
    if (_peripheral.state == CBPeripheralStateConnected)
    {
        return YES;
    }
    
    return NO;
}

- (void)setIsBinding:(BOOL)isBinding
{
    _isBinding = isBinding;
    
    [self updateCurrentModelToDB];
}

- (void)setIsDialingRemind:(BOOL)isDialingRemind
{
    _isDialingRemind = isDialingRemind;
    [self updateCurrentModelToDB];
}

- (void)setDelayDialing:(NSInteger)delayDialing
{
    _delayDialing = delayDialing;
    [self updateCurrentModelToDB];
}

- (void)setIsLostModel:(BOOL)isLostModel
{
    _isLostModel = isLostModel;
    [self updateCurrentModelToDB];
}

- (void)setBatteryQuantity:(NSInteger)batteryQuantity
{
    _batteryQuantity = batteryQuantity;
    [self updateCurrentModelToDB];
}

- (void)setIsTurnHand:(BOOL)isTurnHand
{
    _isTurnHand = isTurnHand;
    [self updateCurrentModelToDB];
}

- (void)setMacAddress:(NSString *)macAddress
{
    _macAddress = macAddress;
    [self updateCurrentModelToDB];
}

- (NSString *)bltNickName
{
    NSString *name = [_bltUUID getObjectValue];
    
    return name ? name : _bltName;
}

/*
- (void)setIsOpenLost:(BOOL)isOpenLost
{
    _isOpenLost = isOpenLost;
    [BLTModel updateToDB:self where:nil];
}

- (void)setLostVolume:(CGFloat)lostVolume
{
    _lostVolume = lostVolume;
    [BLTModel updateToDB:self where:nil];
}

- (void)setFindVolume:(CGFloat)findVolume
{
    _findVolume = findVolume;
    [BLTModel updateToDB:self where:nil];
}

- (void)setIsOpenLostLED:(BOOL)isOpenLostLED
{
    _isOpenLostLED = isOpenLostLED;
    [BLTModel updateToDB:self where:nil];
}

- (void)setIsOpenFindLED:(BOOL)isOpenFindLED
{
    _isOpenFindLED = isOpenFindLED;
    [BLTModel updateToDB:self where:nil];
}

- (void)setDistanceType:(BLTModelLostDistance)distanceType
{
    _distanceType = distanceType;
    [BLTModel updateToDB:self where:nil];
}

- (void)setLostmName:(NSString *)lostmName
{
    _lostmName = lostmName;
    [BLTModel updateToDB:self where:nil];
}

- (void)setFindName:(NSString *)findName
{
    _findName = findName;
    [BLTModel updateToDB:self where:nil];
}
 */

@end
