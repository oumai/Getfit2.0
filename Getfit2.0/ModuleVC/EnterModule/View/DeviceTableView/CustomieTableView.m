//
//  Customie_TableView.m
//  Customize
//
//  Created by 黄建华 on 15/5/25.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "CustomieTableView.h"
#import "BLTModel.h"

@implementation CustomieTableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initTable];
    }
    return self;
}

//- (NSMutableArray *)array {
//    if (self.array == nil) {
//        self.array = [[NSMutableArray alloc] init];
//    }
//    return self.array;
//}

- (void)initTable
{
    _currentindex = 999;
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _table.delegate =self;
    _table.dataSource =self;
    [self addSubview:_table];
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   // [self setExtraCellLineHidden:_table];

}

- (void)setArray:(NSMutableArray *)array
{
    _array = array;
    [self quiteSort:0 and:_array.count - 1];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self quiteSort:0 and:_array.count - 1];
        [_table reloadData];
    });
}

-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColorHEX(0x272727);
    [_table setTableFooterView:view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if (_animationBlock)
    {
        if (_array.count == 0)
        {
            _animationBlock(nil, @(YES));
        }
        else
        {
            _animationBlock(nil, @(NO));
        }
    }
     */
    
    
//    NSLog(@"...%d", _array.count);
    
    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"Customie_TableViewCell";
    CustomieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    if (cell == nil)
    {
        cell = [[CustomieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    
    if (indexPath.row >= _array.count)
    {
        return cell;
    }
    
    BLTModel *model = _array[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    [cell cellUpdate:model];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    for (int i = 0;  i <_array.count ; i ++)
//    {
//        CustomieTableViewCell *  cell = (CustomieTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        
//        if (i == indexPath.row )
//        {
//        cell.selectImage.hidden = NO;
//        }else
//        {
//        cell.selectImage.hidden = YES;
//        }
//
//    }
        _currentindex = indexPath.row;

    if (_devicedidSelectRowBlock)
    {
        _devicedidSelectRowBlock(_currentindex);
        
    }
    
    [[BLTManager sharedInstance] connectPeripheralWithModel:_array[indexPath.row]];
   
    SHOWMBProgressHUD(KK_Text(@"connecting device"), nil, nil, NO, 5.0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)quiteSort:(NSInteger)left and:(NSInteger)right {
    if (left >= right) {
        return;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    BLTModel *letfModel = _array[left];
    BLTModel *rightModel = _array[right];
    NSInteger i = left;
    NSInteger j = right;
    NSInteger base = [letfModel.bltRSSI integerValue];
    for (BLTModel *models in _array) {
        [str appendString:models.bltRSSI];
        [str appendFormat:@" "];
    }
    while (i < j) {
        BLTModel *iModel = _array[i];
        BLTModel *jModel = _array[j];
        while ((i < j) && (base <= [jModel.bltRSSI integerValue])) {
            j--;
        }
        _array[i] = _array[j];
        
        while ((i < j)&& (base >= [iModel.bltRSSI integerValue])) {
            i++;
        }
        _array[j] = _array[i];
    }
    NSLog(@"base = %ld",base);
    NSLog(@"str = %@",str);
    _array[i] = letfModel;
    [self quiteSort:left and:i - 1];
    [self quiteSort:i + 1 and:right];
}
@end
