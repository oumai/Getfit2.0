//
//  SedentaryReminderTableView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "SedentaryReminderTableView.h"

@implementation SedentaryReminderTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self loadTableView];
    }
    
    return self;
}

- (void)loadTableView
{
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    line1.backgroundColor = UIColorHEX(0x888b90);
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 55, self.width, 0.5)];
    line2.backgroundColor = UIColorHEX(0x888b90);
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, self.width, 0.5)];
    line3.backgroundColor = UIColorHEX(0x888b90);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    _tableView.scrollEnabled = NO;
    
    [_tableView addSubview:line1];
    [_tableView addSubview:line2];
    [_tableView addSubview:line3];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _timeArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (void)setTimeArray:(NSMutableArray *)timeArray
{
    _timeArray = timeArray;
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"SedentaryReminderTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
        UILabel *title = [[UILabel alloc]init];
        title.frame =CGRectMake(10, 35.0/2 , 80, 20);
        title.textColor = [UIColor whiteColor];
        title.font = DEFAULT_FONTHelvetica(14);
        title.tag = indexPath.row + 100;
        [cell addSubview:title];
        
        UILabel *selectTimeLabel = [[UILabel alloc]init];
        selectTimeLabel.frame =CGRectMake(self.width - 110, 35.0/2 , 100, 20);
        selectTimeLabel.textAlignment = NSTextAlignmentRight;
        selectTimeLabel.textColor = [UIColor whiteColor];
        selectTimeLabel.font = DEFAULT_FONTHelvetica(14);
        selectTimeLabel.tag = indexPath.row + 200;
        [cell addSubview:selectTimeLabel];
        
    }
        cell.backgroundColor = [UIColor clearColor];
        UILabel *title = (UILabel *)[cell viewWithTag:100 +indexPath.row];
        if (indexPath.row == 0)
        {
            title.text = KK_Text(@"Start");
        }
        else if(indexPath.row == 1)
        {
            title.text = KK_Text(@"End");
        }
    
        UILabel *selectTimeLabel = (UILabel *)[cell viewWithTag:200 +indexPath.row];
        selectTimeLabel.text = [_timeArray objectAtIndex:indexPath.row];
    
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        cell.selectedBackgroundView.backgroundColor = UIColorHEX(0x363636);
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [_SedentaryReminderSelectDelegate SedentaryReminderSelect:indexPath.row];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
