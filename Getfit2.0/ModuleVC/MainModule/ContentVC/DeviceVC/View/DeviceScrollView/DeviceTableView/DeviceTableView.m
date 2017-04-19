//
//  DeviceTableView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceTableView.h"
#import "DeviceInfoClass.h"
#import "DeviceTableViewCell.h"
#import "BLTSimpleSend.h"

@implementation DeviceTableView
{
    UIActionSheet *_sheet;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadTableView];
        [self loadTabHeadView];
    }
    
    return self;
}
- (void)loadTableView
{
  
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    self.backgroundColor = UIColorHEX(0x262626);
    
    
}

- (void)updateTableView
{

    NSLog(@"deviceFunctionList >>>%@",_deviceFunctionList);
    
    [_tableView reloadData];
}

- (void)loadTabHeadView
{
    CGFloat width = 40;
    _redHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Maxwidth, 135)];
    _redHeaderView.backgroundColor = BGCOLOR;
    [self addSubview:_redHeaderView];
    
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 96, 96)];
    iconImageView.image = UIImageNamed(@"Device_big_circle_5s@2x");
    [_redHeaderView addSubview:iconImageView];
    
    _deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(156 - width, 28, Maxwidth - 156 + width, 20)];
    _deviceNameLabel.text = [[DeviceInfoClass sharedInstance] bltDeviceName];
    _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
    _deviceNameLabel.textColor = [UIColor whiteColor];
    [_deviceNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.]];
    [_redHeaderView addSubview:_deviceNameLabel];
    
    _updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(156 - width, 50, 200 + width, 20)];
    _updateTimeLabel.text = [[DeviceInfoClass sharedInstance] updateDataTime];
    _updateTimeLabel.textAlignment = NSTextAlignmentLeft;
    _updateTimeLabel.textColor = [UIColor whiteColor];
    [_updateTimeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.]];
    [_redHeaderView addSubview:_updateTimeLabel];
    
    
    _firmwareVersion = [[UILabel alloc] initWithFrame:CGRectMake(156 - width, 68, 200 + width, 20)];
    _firmwareVersion.textAlignment = NSTextAlignmentLeft;
    _firmwareVersion.textColor = [UIColor whiteColor];
    [_firmwareVersion setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.]];
    [_redHeaderView addSubview:_firmwareVersion];
    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(156 - width, 85, 200 + width, 20)];
    [_levelLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.]];
    _levelLabel.textAlignment = NSTextAlignmentLeft;
    _levelLabel.textColor = [UIColor whiteColor];
    [_redHeaderView addSubview:_levelLabel];
    
    _macLabel = [[UILabel alloc] initWithFrame:CGRectMake(156 - width, 102, 200 + width, 20)];
    [_macLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11.]];
    _macLabel.textAlignment = NSTextAlignmentLeft;
    _macLabel.textColor = [UIColor whiteColor];
    [_redHeaderView addSubview:_macLabel];
    
    _tableView.tableHeaderView =_redHeaderView;
  
    _boindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _boindButton.backgroundColor = [UIColor grayColor];
    _boindButton.frame = CGRectMake(0, self.height - 50, self.width, 44);
    
    if ([UserInfoHelper sharedInstance].bltModel.isBinding)
    {
        [_boindButton setTitle:KK_Text(@"Unbind") forState:UIControlStateNormal];
        _boindButton.tag = 111;
    }
    else
    {
        _boindButton.tag = 222;
       [_boindButton setTitle:KK_Text(@"Pair Device") forState:UIControlStateNormal];
    }
    
    [_boindButton addTarget:self action:@selector(boindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"isBinding %i",[UserInfoHelper sharedInstance].bltModel.isBinding);
    
    [_boindButton setBackgroundImage:[UIImage imageNamed:@"Device_big_btn_2_5s@2x"] forState:UIControlStateHighlighted];
    [self addSubview:_boindButton];
}

- (void)updateContentForSubViews
{
    BLTModel *model = [BLTManager sharedInstance].model;
    _levelLabel.text = [NSString stringWithFormat:@"%@:%ld%%", KK_Text(@"Battery remaining"), (long)model.batteryQuantity];
    _macLabel.text = [NSString stringWithFormat:@"MAC:%@", model.macAddress ? model.macAddress : @""];

    if (model.bltVersion > 0) {
        _firmwareVersion.text = [NSString stringWithFormat:@"%@:V%ld", KK_Text(@"Firmware version"), (long)model.bltVersion];
    } else {
        _firmwareVersion.text = [NSString stringWithFormat:@"%@:V-", KK_Text(@"Firmware version")];
    }
    
    _updateTimeLabel.text = [[DeviceInfoClass sharedInstance] updateDataTime];
    _deviceNameLabel.text = [[DeviceInfoClass sharedInstance] bltDeviceName];
    _deviceTableView.array = [BLTManager sharedInstance].allWareArray;
    
    if ([UserInfoHelper sharedInstance].bltModel.isBinding) {
        [_boindButton setTitle:KK_Text(@"Unbind") forState:UIControlStateNormal];
        _boindButton.tag = 111;
    } else {
        _boindButton.tag = 222;
        [_boindButton setTitle:KK_Text(@"Pair Device") forState:UIControlStateNormal];
    }
    
    [_tableView reloadData];
}

// 绑定与解绑
- (void)boindButtonClick:(UIButton *)sender
{
    if (sender.tag == 111)
    {
        _sheet = [[UIActionSheet alloc] initWithTitle:KK_Text(@"Unbind the device? \nData waitting for sync will be lost.")
                                             delegate:self
                                    cancelButtonTitle:KK_Text(@"Cancel")
                               destructiveButtonTitle:nil
                                    otherButtonTitles:KK_Text(@"Delete Device"), nil];
        [_sheet showInView:self];
    }
    else
    {
        if (![UserInfoHelper sharedInstance].bltModel.isBinding) {
            if (_bondingBlock) {
                _bondingBlock();
            }
        }else {
            _sheet = [[UIActionSheet alloc] initWithTitle:KK_Text(@"Unbind the device? \nData waitting for sync will be lost.")
                                                 delegate:self
                                        cancelButtonTitle:KK_Text(@"Cancel")
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:KK_Text(@"Delete Device"), nil];
            [_sheet showInView:self];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return _deviceFunctionList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"deviceDidselectRow" object:[NSString stringWithFormat:@"%d",[self indexRow:indexPath]]];
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deviceDidselectRow" object:[NSString stringWithFormat:@"%@",[_deviceFunctionList objectAtIndex:indexPath.row]]];
    
}

- (NSInteger)indexRow:(NSIndexPath*)indexPath
{
    NSInteger row = 0;
    
    if (indexPath.section == 0)
    {
        row = indexPath.row;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"DeviceTableViewCell";
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    
    if (cell == nil) {
        cell = [[DeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell DeviceTableViewUpdateCell:[_deviceFunctionList objectAtIndex:indexPath.row] tableindexPath:indexPath];
    
    NSString *title = [_deviceFunctionList objectAtIndex:indexPath.row];
    if ([title isEqualToString:KK_Text(@"device upgrade")])
    {
        int versionFirmware = [[DeviceInfoClass sharedInstance]currentVersion].intValue;  ///当前版本
        
        if (versionFirmware >= 100)
        {
            cell.userInteractionEnabled = NO; ///最新版本不能被选
            cell.openStateLabel.text = KK_Text(@"Already Latest Version");
        }
    }
    
    //波兰语按钮和语言都标识  应该是有了 按钮就没有 语言
    if ( indexPath.row == 6|| indexPath.row == 7|| indexPath.row == 8|| indexPath.row == 9) {
        cell.openStateLabel.hidden = YES;
    }
    return  cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 20.0;
//}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
    view.backgroundColor = UIColorHEX(0x363636);
    return view;
}



//确定绑定按钮 跳转个人资料设置
- (void)BindingDevice
{
    [BLTManager sharedInstance].model.isBinding = YES;
    SHOWMBProgressHUD(KK_Text(@"Bind Success"), nil, nil, NO, 2.0);
    [_boindButton setTitle:KK_Text(@"Unbind") forState:UIControlStateNormal];
    [_deviceViewBackGround dismissPopup];  ////绑定成功后,列表视图消失
    // 绑定后同步数据.

}

- (void)refreshDeviceView
{
    [[BLTManager sharedInstance]scan];
    SHOWMBProgressHUD(KK_Text(@"Scanning"), nil, nil, NO, 2.0);
}

- (void)didselect:(NSInteger)index
{
    NSLog(@"选择了设备>>>%@",_deviceTableView.array[index]);
    
}


#pragma mark --- actionsheetDelegate -----
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index = %ld",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            if([UserInfoHelper sharedInstance].bltModel.isConnected) {
                [[UserInfoHelper sharedInstance] unpairCurrentDeviceWithBackBlock:^(id object) {

                    if ([object integerValue] == 1)
                    {
                        _boindButton.tag = 222;
                        [_boindButton setTitle:KK_Text(@"Bind Device") forState:UIControlStateNormal];
                    }
                    
                }];
            }
            else{
                _boindButton.tag = 222;
                [_boindButton setTitle:KK_Text(@"Bind Device") forState:UIControlStateNormal];
                BLTModel *model = [UserInfoHelper sharedInstance].bltModel;
                model.isBinding = NO;
                model.isRepeatConnect = NO;
                SHOWMBProgressHUD(KK_Text(@"Unbind Success"), nil, nil, NO, 2.0);
            }
        }
            break;
        case 1:
            break;
        default:
            break;
    }
}

@end
