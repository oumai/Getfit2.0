//
//  ShapeView.m
//  DrayPointTest
//
//  Created by xun on 14-3-25.
//  Copyright (c) 2014年 xun. All rights reserved.
//

#import "ShapeView.h"


@implementation ShapeView


+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer
{
    return (CAShapeLayer *)self.layer;
}

@end
