//
//  Customie_TableView.h
//  Customize
//
//  Created by 黄建华 on 15/5/25.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomieTableViewCell.h"
#import "BLTManager.h"

typedef void(^devicedidSelectRow)  (NSInteger Index);
@interface CustomieTableView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger currentindex;
@property (nonatomic, strong) devicedidSelectRow devicedidSelectRowBlock;
@property (nonatomic, strong) UIViewSimpleBlock animationBlock;

@end
