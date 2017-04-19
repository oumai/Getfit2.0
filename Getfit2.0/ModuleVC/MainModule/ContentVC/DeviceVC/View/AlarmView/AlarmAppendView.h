//
//  AlarmAppendView.h
//  custom_button
//
//  Created by 黄建华 on 15/7/8.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmTypePickerView.h"
#import "DeviceInfoClass.h"
#import "WeekView.h"
#import "QS_PickUpView.h"
#import "AlarmClockModel.h"

@interface AlarmAppendView : UIView <PickUpDelegate,UITextFieldDelegate>


@property (nonatomic, strong) UIView *remindView;
@property (nonatomic, strong) UIView *repeatView;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UIButton *remindButton;   // 提醒按钮
@property (nonatomic, strong) UIButton *repeatButton;   // 重复按钮
@property (nonatomic, strong) UIButton *timeButton;     // 时间按钮
@property (nonatomic, strong) UIButton *nameButton;     // 备注按钮
@property (nonatomic, strong) NSArray *titleArray;      // 标题
@property (nonatomic, strong) NSArray *alarmTypeArray;  //闹钟类型数组
@property (nonatomic, assign) CGFloat originy;
@property (nonatomic, strong) UILabel *alarmTypeLabel;
@property (nonatomic, strong) UILabel *alarmWeekLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *alarmRemarksLabel; // 备注
@property (nonatomic, strong) UIButton *lastButton; // 保存上次按钮
@property (nonatomic, assign) NSInteger currentMeum;

@property (nonatomic, strong) AlarmTypePickerView *alarmTypePickView;
@property (nonatomic, strong) WeekView *WeekView;
@property (nonatomic, strong) QS_PickUpView *timepickView;
@property (nonatomic, strong) UITextField * remarkText;
@property (nonatomic, strong) UIView *remarkTextBgView;

@property (nonatomic, strong) AlarmClockModel *model;

- (instancetype)initWithFrame:(CGRect)frame withModel:(AlarmClockModel *)model;

- (void)showAlarmAppendView:(NSDictionary *)alarmDic alarmIndex:(NSInteger)index;

- (NSMutableDictionary*)saveAlarm;


@end
