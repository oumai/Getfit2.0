//
//  NoneFamilyTipsView.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/4.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "NoneFamilyTipsView.h"
#import "ZHObject.h"
#import "UIViewAdditions.h"
@implementation NoneFamilyTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    ZHVoidBlock _creat;
    ZHVoidBlock _search;
    ZHVoidBlock _erweima;
}
-(void)setCreatBlock:(ZHVoidBlock)creat AndErWeiMaBlock:(ZHVoidBlock)erweima AndSearchBlock:(ZHVoidBlock)search
{
    _creat = creat;
    _erweima = erweima;
    _search = search;
    
    _joinButton.titleNormal = KK_Text(@"Search");
    _searchButton.titleNormal = KK_Text(@"Create group");
    _joinButton.backgroundColor = KK_MainColor;
    _searchButton.backgroundColor = KK_MainColor;
}
///加入家庭圈
- (IBAction)attendFamily:(id)sender
{
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:KK_Text(@"Search") cancelButtonItem:[RIButtonItem itemWithLabel:KK_Text(@"Cancel")] destructiveButtonItem:nil otherButtonItems:[RIButtonItem itemWithLabel:KK_Text(@"Scan QR code") action:^{
        if (_erweima)
        {
            _erweima();
        }
    }],[RIButtonItem itemWithLabel:KK_Text(@"SearchID") action:^{
        if (_search)
        {
            _search();
        }
    }], nil];
    [sheet showInView:self.window];
}
///创建家庭圈
- (IBAction)creatFamily:(id)sender
{
    if (_creat)
    {
        _creat();
    }
}
-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [[self viewWithTag:222]setCornerRadiusss:4];
    [[self viewWithTag:333]setCornerRadiusss:4];
    
  
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
  
    }
    return self;
}

@end
