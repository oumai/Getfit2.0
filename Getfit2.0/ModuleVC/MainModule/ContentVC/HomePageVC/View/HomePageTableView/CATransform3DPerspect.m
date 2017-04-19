//
//  CATransform3DPerspect.m
//  IOS_3D_UI
//
//  Created by  on 9/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "CATransform3DPerspect.h"

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ ,float value )
{
//    NSLog(@"zzz == %f",value);
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, value);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ,float step )
{
//    NSLog(@"%f,%f",step/1.570796,floor(step/1.570796));
    float value = 0.0;
    float stepValue = step/1.570796 - floor(step/1.570796);
    if (stepValue < 0.5) {
        value = -180 * stepValue;
    }else if (stepValue >= 0.5){
        value = -180 * (1 - stepValue);
    }
    if (stepValue == 0) {
        value = 0.0f;
    }
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ, value));
}