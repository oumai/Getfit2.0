//
//  UILabel+Simple.m
//  AJBracelet
//
//  Created by zorro on 15/5/27.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UILabel+Simple.h"

@implementation UILabel (Simple)

+ (UILabel *)simpleWithRect:(CGRect)rect;
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    return label;
}

+ (UILabel *)simpleWithRect:(CGRect)rect
              withAlignment:(NSTextAlignment)alignment
               withFontSize:(CGFloat)size
                   withText:(NSString *)text
              withTextColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:size];
    label.text = text ? text : @"";
    label.textColor = textColor;
    
    return label;
}

#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;

- (CGSize)estimateUISizeByHeight:(CGFloat)height
{
    if ( nil == self.text || 0 == self.text.length )
        return CGSizeMake( 0.0f, height );
    
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(10000, 0)
                                          options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    return size;
}


@end
