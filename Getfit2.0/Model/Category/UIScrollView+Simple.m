//
//  UIScrollView+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UIScrollView+Simple.h"

@implementation UIScrollView (Simple)

+ (UIScrollView *)simpleWithRect:(CGRect)rect
                        withShow:(BOOL)show
                      withBounce:(BOOL)bounce
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = show;
    scrollView.showsVerticalScrollIndicator = show;
    scrollView.bounces = bounce;
    
    return scrollView;
}

@end

@implementation UITableView (Simple)

+ (UITableView *)simpleWithRect:(CGRect)rect
                   withDelegate:(id)object
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    
    tableView.dataSource = object;
    tableView.delegate = object;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    
    return tableView;
}

@end
