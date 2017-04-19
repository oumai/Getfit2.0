//
//  CustomTopView.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/10.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "CustomTopView.h"

#import "SPTribeProfileViewController.h"
#import "SPTribeConversationViewController.h"

@implementation CustomTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)popBack:(id)sender
{
    [self.controller.navigationController popViewControllerAnimated:YES];
}

- (YWTribeConversation *)tribeConversation {
    
    SPTribeConversationViewController *vc = self.controller;
    
    
    if ([vc.conversation isKindOfClass:[YWTribeConversation class]]) {
        return (YWTribeConversation *)vc.conversation;
    }
    return nil;
}
- (IBAction)groupDetails:(UIButton *)sender {
    
    UIStoryboard *tribeStoryboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
    SPTribeProfileViewController *controller =  [tribeStoryboard instantiateViewControllerWithIdentifier:@"SPTribeProfileViewController"];
    if (controller) {
        controller.tribe = [self tribeConversation].tribe;
        
        __weak SPTribeProfileViewController *weakCtrl = controller;
        __weak CustomTopView *weakSelf = self;

        controller.exitBlock = ^ (NSObject *object) {
            [weakCtrl dismissViewControllerAnimated:NO completion:nil];
            [weakSelf.controller.navigationController popViewControllerAnimated:YES];
        };
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        navigationController.navigationBar.barTintColor = KK_MainColor;
        // navigationController.navigationBar.backgroundColor = KK_MainColor;
        
        [self.controller presentViewController:navigationController
                           animated:YES
                         completion:nil];
    }
}

@end
