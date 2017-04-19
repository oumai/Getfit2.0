//
//  SPInputViewPluginCustomize.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 4/29/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import "SPInputViewPluginCustomize.h"

#import "SPKitExample.h"

@interface SPInputViewPluginCustomize ()

@property (nonatomic, readonly) YWConversationViewController *conversationViewController;

@end

@implementation SPInputViewPluginCustomize

#pragma mark - properties

- (YWConversationViewController *)conversationViewController
{
    if ([self.inputViewRef.controllerRef isKindOfClass:[YWConversationViewController class]]) {
        return (YWConversationViewController *)self.inputViewRef.controllerRef;
    } else {
        return nil;
    }
}


#pragma mark - YWInputViewPluginProtocol

/**
 * 您需要实现以下方法
 */

// 插件图标
- (UIImage *)pluginIconImage
{
    return [UIImage imageNamed:@"input_plug_ico_hi_nor"];
}

// 插件名称
- (NSString *)pluginName
{
    return @"打招呼";
}

// 插件对应的view，会被加载到inputView上
/// 你必须提供一个固定的view，而不是每次都重新生成，否则在收拢面板时无法移除该view
- (UIView *)pluginContentView
{
    return nil;
}

// 插件被选中运行
/// 你可以在这个里面，调用'YWMessageInputView.h'的'pushContentViewOfPlugin:'函数，控制显示出'pluginContentView'的面板
- (void)pluginDidClicked
{
    [[SPKitExample sharedInstance] exampleSendCustomMessageWithConversationController:self.conversationViewController];
}


@end
