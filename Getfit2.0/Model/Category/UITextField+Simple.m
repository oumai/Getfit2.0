//
//  UITextField+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UITextField+Simple.h"

@implementation UITextField (Simple)

+ (UITextField *)simpleWithRect:(CGRect)rect
                withPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.backgroundColor = [UIColor clearColor];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:18.0];
    
    return textField;
}

+ (UITextField *)simpleWithRect:(CGRect)rect
                      withImage:(NSString *)imageString
                withPlaceholder:(NSString *)placeholder
                       withFont:(CGFloat)size
{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.backgroundColor = [UIColor clearColor];
    //_textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.background = [UIImage imageNamed:imageString];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    [textField changePlaceholder:placeholder
                       withColor:[UIColor lightGrayColor]
                        withFont:size];
    
    return textField;
}

- (void)changePlaceholder:(NSString *)placeholder
                withColor:(UIColor *)color
                 withFont:(CGFloat)size
{
    self.placeholder = placeholder;
    UIFont *font = [UIFont systemFontOfSize:size];
    self.font = font;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                 attributes:@{NSForegroundColorAttributeName : color,
                                                                              NSFontAttributeName : font}];
}

@end
