//
//  DeviceInfoClass.m
//  AJBracelet
//
//  Created by 黄建华 on 15/6/30.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "DeviceInfoClass.h"
#import "RemindModel.h"

@implementation DeviceInfoClass

DEF_SINGLETON (DeviceInfoClass)

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

- (void)loadData
{
 
}

- (NSString*)updateDataTime
{
    NSDate *senddate = [USERUPDATEDATETIME getObjectValue];
    NSDateFormatter *dateformatter = [NSDate dateFormatterTemp];
    [dateformatter setDateFormat:@"YY/MM/dd HH:mm"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    NSString *updateString = [NSString stringWithFormat:@"%@ %@", KK_Text(@"Data synced at"), locationString];
    if ([UserInfoHelper sharedInstance].bltModel.bltName == NULL)
    {
        return locationString;
    }

    return updateString;
}

// 返回设备界面 功能开启状态
- (NSString *)Callreminder:(NSString *)title
{
    BOOL state = NO;
    
    NSLog(@"title = %@",title);
    
    if ([title isEqualToString:KK_Text(@"Call Alert")])
    {
        state = [UserInfoHelper sharedInstance].bltModel.isDialingRemind;
    }
    else if ([title isEqualToString:KK_Text(@"Sedentary Alert")])
    {
        RemindModel *model = [[UserInfoHelper sharedInstance].bltModel.remindArray lastObject];
        state = model.isOpen;
    }
    else if ([title isEqualToString:KK_Text(@"Remind drink")])
    {
        DrinkModel *model = [UserInfoHelper sharedInstance].bltModel.drinkModel;
        state = model.isOpen;
    }
    else if ([title isEqualToString:KK_Text(@"Alarm Alert")])
    {
        NSArray *alarmArray =  [UserInfoHelper sharedInstance].bltModel.alarmArray;
        
        int alarmOpenCount = 0;
        for (AlarmClockModel *model in alarmArray)
        {
            if (model.isOpen)
            {
                alarmOpenCount ++;
            }
        }
        if (alarmOpenCount == 0)
        {
            return KK_Text(@"OFF");
        }
        else if (alarmOpenCount == 1)
        {
            return KK_Text(@"ON");
        }
        else
        {
            return KK_Text(@"MultiLists");
        }
    }
    else if ([title isEqualToString:KK_Text(@"Photograph")])
    {
        return @"";
    }
    else if ([title isEqualToString:KK_Text(@"Anti-lost Alert")]){
        return @"";
    }
    else if ([title isEqualToString:KK_Text(@"device upgrade")])
    {
        return @"";
    }
    
    
    if (state)
    {
        return KK_Text(@"ON");
    }
    else
    {
        return KK_Text(@"OFF");
    }
}

// 手环设备名字
- (NSString *)bltDeviceName
{
    if ([UserInfoHelper sharedInstance].bltModel.bltName == NULL)
    {
        return KK_Text(@"Please pair the device");
    }
    else
    {
        return  [UserInfoHelper sharedInstance].bltModel.bltNickName;
    }
}

// 电量
- (NSString *)batteryLevel
{
    return [NSString stringWithFormat:@"%d",[UserInfoHelper sharedInstance].bltModel.batteryQuantity];
}

- (NSString *)currentVersion
{
     return [NSString stringWithFormat:@"%d",[UserInfoHelper sharedInstance].bltModel.bltVersion];
}

- (NSString *)firmwareVersion
{
    return [NSString stringWithFormat:@"%@",_firmwareLastVersion];
}

- (void)setFirmwareLastVersion:(NSString *)firmwareLastVersion
{
    _firmwareLastVersion = firmwareLastVersion;
}

- (UIImage *)alarmIconImage:(NSString*)alarmType
{
    if ([alarmType isEqualToString:KK_Text(@"Exercise")])
    {
        return UIImageNamedNoCache(@"device_alarm_sport_5@2x.png");
    }
    else if ([alarmType isEqualToString:KK_Text(@"Take Medication")])
    {
        return UIImageNamedNoCache(@"device_alarm_pill_5@2x.png");
    }
    else if ([alarmType isEqualToString:KK_Text(@"Get Up")])
    {
        return UIImageNamedNoCache(@"device_alarm_wakeup_5@2x.png");
    }
    else if ([alarmType isEqualToString:KK_Text(@"Go to sleep")])
    {
        return UIImageNamedNoCache(@"device_alarm_sleep_5@2x.png");
    }
    else if ([alarmType isEqualToString:KK_Text(@"Dating")])
    {
        return UIImageNamedNoCache(@"device_alarm_dating_5@2x.png");
    }
    else if ([alarmType isEqualToString:KK_Text(@"Party")])
    {
        return UIImageNamedNoCache(@"device_alarm_together_5@2x.png");
    }
    else if ([alarmType isEqualToString:KK_Text(@"Meeting")])
    {
        return UIImageNamedNoCache(@"device_alarm_meeting_5@2x.png");
    }
    else
    {
        return UIImageNamedNoCache(@"device_alarm_customize_5@2x.png");
    }
}

- (NSInteger)alarmType:(NSString *)alarmType
{
    NSInteger count = 0;
    if ([alarmType isEqualToString:KK_Text(@"Get Up")])
    {
       count = 0;
    }
    else if ([alarmType isEqualToString:KK_Text(@"Go to sleep")])
    {
       count = 1;
    }
    else if ([alarmType isEqualToString:KK_Text(@"Exercise")])
    {
       count = 2;
    }
    else if ([alarmType isEqualToString:KK_Text(@"Take Medication")])
    {
       count = 3;
    }
    else if ([alarmType isEqualToString:KK_Text(@"Dating")])
    {
       count = 4;
    }
    else if ([alarmType isEqualToString:KK_Text(@"Party")])
    {
       count = 5;
    }
    else if ([alarmType isEqualToString:KK_Text(@"Meeting")])
    {
       count = 6;
    }
    else
    {
       count = 7;
    }
    return count;
}

- (NSArray *)alarmtTypeArray
{
    NSArray *alarmtType = [[NSArray alloc]initWithObjects:KK_Text(@"Get Up"),
                           KK_Text(@"Go to sleep"),
                           KK_Text(@"Exercise"),
                           KK_Text(@"Take Medication"),
                           KK_Text(@"Dating"),
                           KK_Text(@"Party"),
                           KK_Text(@"Meeting"),
                           KK_Text(@"Custom"),
                           nil];
    return alarmtType;
}

@end
