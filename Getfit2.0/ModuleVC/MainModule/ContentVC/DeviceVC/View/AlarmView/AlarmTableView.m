//
//  AlarmTableView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/7.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "AlarmTableView.h"
#import "alarmTableViewCell.h"
#import "DeviceInfoClass.h"
#import "AlarmClockModel.h"
#import "UserInfoHelper.h"

@implementation AlarmTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadTableView];
    }
    
    return self;
}

// 刷新tableView;
- (void)setAlarmArray:(NSArray *)alarmArray
{
    _alarmArray = alarmArray;
    
    [_tableView reloadData];
}

- (void)loadTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    _editState = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirmbutton:) name:@"confirmbutton" object:nil];

}

- (void)tableViewDismiss
{
  [[NSNotificationCenter defaultCenter]removeObserver:self name:@"confirmbutton" object:nil]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _alarmArray.count + 1;
}

#define AlarmTableView_CellHeight (64.0)
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_alarmArray.count > 0 && indexPath.row < _alarmArray.count)
    {
        AlarmClockModel *model = _alarmArray[indexPath.row];
        
        return model.showHeight;
    }
    
    return AlarmTableView_CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"alarmTableViewCell";
    alarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    
    if (cell == nil)
    {
        cell = [[alarmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    
    if (_alarmArray.count > indexPath.row)
    {
        [cell alarmTableViewUpdateCell:_alarmArray[indexPath.row] withHeight:AlarmTableView_CellHeight];
    }
    else
    {
        [cell alarmTableViewUpdateCell:nil withHeight:AlarmTableView_CellHeight];
    }
    
    if (indexPath.row == _alarmArray.count || !_alarmArray)
    {
        NSInteger alarmCount = 0;
        for (AlarmClockModel *model in _alarmArray)
        {
            if (model.showHeight >0)
            {
                alarmCount++;
            }
        }
        
        if (alarmCount == 3)
        {
            NSLog(@"禁止添加  >>>闹钟 ");
            cell.addAlarmButton.hidden = YES;
            cell.addAlarmLabel.hidden = YES;
            cell.whiteLine.hidden = YES;
            return cell;
        }
        else
        {
            cell.addAlarmButton.hidden = NO;
            cell.addAlarmLabel.hidden = NO;
            cell.whiteLine.hidden = NO;
            
        }
        
        [cell.addAlarmButton addTarget:self action:@selector(addalarmSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.alarmSwitchButton.tag = indexPath.row;
    }
    
    if (indexPath.row  == 9)
    {
        cell.whiteLine.hidden = NO;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _alarmArray.count)
    {
        return;
    }
    
    [self showAlarmView:indexPath.row];
}

// 删除闹钟
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AlarmClockModel *model = _alarmArray[indexPath.row];
        model.showHeight = 0;
        model.isSys = NO;
        
        [self animationWithViewTransition:^(UIView *aView, id object) {
            [tableView reloadData];
        }];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _alarmArray.count)
    {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KK_Text(@"Delete");
}

- (void)showAlarmView:(NSInteger)alarmIndex
{
    _editState = YES;

    _tableView.hidden = YES;
    
    if (_alarmAppendView && [_alarmAppendView superview])
    {
        [_alarmAppendView removeFromSuperview];
        _alarmAppendView = nil;
    }
    
    AlarmClockModel *model = _alarmArray[alarmIndex];
    _alarmAppendView = [[AlarmAppendView alloc] initWithFrame:CGRectMake(10, 109, self.width -20, 568 - 109) withModel:model];
    
    [self animationWithViewTransition:^(UIView *aView, id object) {
        [self addSubview:_alarmAppendView];
    }];
}

- (void)addalarmSwitchButton:(UIButton *)sender
{
    NSLog(@"添加闹钟");
    
    for (int i = 0; i < _alarmArray.count; i++)
    {
        AlarmClockModel *model = _alarmArray[i];
        
        if (model.showHeight < 20.0)
        {
            model.showHeight = AlarmTableView_CellHeight;
            
            [self animationWithViewTransition:^(UIView *aView, id object) {
                [_tableView reloadData];
            }];
            
            return;
        }
    }
    
    SHOWMBProgressHUD(KK_Text(@"3 alarm lists could be added"), nil, nil, NO, 2.0);
}

// 保存闹钟
- (void)confirmbutton:(NSNotification*)info
{
    NSMutableDictionary *alarm = [[NSMutableDictionary alloc]init];
    NSLog(@"编辑》》》》%@",alarm);

    _editState = NO;

    [_tableView setHidden:NO];
    [_alarmAppendView setHidden:YES];
    [_tableView reloadData];
    
    //保存模型 到数组

}

@end
