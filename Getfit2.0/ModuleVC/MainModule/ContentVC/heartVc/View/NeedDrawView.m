
//
//  NeedDrawView.m
//  DrayPointTest
//
//  Created by xun on 14-3-25.
//  Copyright (c) 2014年 xun. All rights reserved.
//

#import "NeedDrawView.h"
#import "ShapeView.h"

static CFTimeInterval const kDuration = 1.0;
static CGFloat const kPointDiameter = 0.0;

@interface NeedDrawView ()

@property (nonatomic, strong) NSMutableArray *allPoints;
@property (nonatomic, strong) NSMutableArray *curPoints;
@property (nonatomic, strong) NSMutableArray *remarkDataArray;
@property (nonatomic, strong) UIView *dotView;

@end

@implementation NeedDrawView

#pragma mark ---------
#pragma mark LifeCycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.contentMode =UIViewContentModeScaleAspectFill;
        _remarkDataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //清除上一次的画板
    CGContextRef ctxxx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctxxx, rect);
    
    [self drawString:_needDrawString withPoint:_curPoint];
    
    //前面已经显示的条目清空后直接重新划在上面
    if (_chargeIndex)
    {
        for (int i = 0; i < _chargeIndex; i++) {
            [self drawString:@"" withPoint:[[self.titlePoints objectAtIndex:i] CGPointValue]];
        }
    }
}

#pragma mark ---------
#pragma mark CustormAPI

- (void)UpdateData:(NSArray *)array isAnimation:(BOOL)isAnimation
{
    if (array == nil) {
        return;
    }
    
    _isAnimation = isAnimation;
    self.titlePoints = @[[NSValue valueWithCGPoint:CGPointMake(100, 10)],[NSValue valueWithCGPoint:CGPointMake(200, 10)],[NSValue valueWithCGPoint:CGPointMake(300, 10)]];
    if (_remarkDataArray) {
        [_remarkDataArray removeAllObjects];
    }

    [_remarkDataArray addObjectsFromArray:array];
    
//   NSLog(@"心率数据>>%@",_remarkDataArray);

    self.allPoints = [NSMutableArray arrayWithObjects:_remarkDataArray, nil];
    // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self showLinesAnimationBegin];//显示线条动画
}

- (void)showLinesAnimationBegin
{
    self.curPoints = [self.allPoints objectAtIndex:_lindex];
    //添加path的UIView
    ShapeView  *pathShapeView = [[ShapeView alloc] init];
    pathShapeView.backgroundColor = [UIColor clearColor];
    pathShapeView.opaque = NO;
    pathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:pathShapeView];

    //设置线条的颜色
    UIColor *pathColor = nil;

    switch (_lindex)
    {
        case 0:
            pathColor = [UIColor whiteColor];
            break;
        case 1:
            pathColor = [UIColor whiteColor];
            break;
        case 2:
            pathColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
    
    pathShapeView.shapeLayer.fillColor = nil;
    pathShapeView.shapeLayer.strokeColor = pathColor.CGColor;
    pathShapeView.shapeLayer.lineWidth = 1.5;
    
    //创建动画
    if (_isAnimation) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @0.0;
        animation.toValue = @1.0;
        animation.delegate = self;
        animation.duration = kDuration;
        [pathShapeView.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    }
   
    [self updatePathsWithPathShapeView:pathShapeView];
}

- (void)updatePathsWithPathShapeView:(ShapeView *)pathShapeView
{
    if ([self.curPoints count] >= 2) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:[[self.curPoints firstObject] CGPointValue]];
        
        //设置路径的颜色和动画
        CGPoint point = [[self.curPoints firstObject] CGPointValue];
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:kPointDiameter / 2.0 startAngle:0.0 endAngle:2 * M_PI clockwise:YES]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [self.curPoints count] - 1)];
        [self.curPoints enumerateObjectsAtIndexes:indexSet
                                       options:0
                                    usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                                        [path addLineToPoint:[pointValue CGPointValue]];
                                        [path appendPath:[UIBezierPath bezierPathWithArcCenter:[pointValue CGPointValue] radius:kPointDiameter / 2.0 startAngle:0.0 endAngle:2 * M_PI clockwise:YES]];
                                        

                                    }];
        path.usesEvenOddFillRule = YES;
        pathShapeView.shapeLayer.path = path.CGPath;
    }
    else {
        pathShapeView.shapeLayer.path = nil;
    }
}

- (NSArray *)handleArrayAllObjectWithNewlineCharacters:(NSArray *)array
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[array count]];
    for (int i = 1; i <= [array count]; i++) {
        NSString *titlesString = [array objectAtIndex:i-1];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:[titlesString length]];
        for (int m = 0; m < [titlesString length]; m++) {
            NSString *charS = [titlesString substringWithRange:NSMakeRange(m, 1)];
            [tempArray addObject:charS];
        }
        NSString *string = [tempArray componentsJoinedByString:@"\n"];
        [titles addObject:string];
    }
    return [titles copy];
}

/*
 *改变当前需要显示的那个String
 */
- (void)updateCurrentString
{
    static int m = 1;
    if (m == [_curString length]+1) {
        [self.timer invalidate];
        self.timer = nil;
        m = 1;
        ++_chargeIndex;
        return;
    } else {
        _needDrawString  = [_curString substringWithRange:NSMakeRange(0,m)];
        m++;
        [self setNeedsDisplay];
    }
}

- (void)drawString:(NSString *)text withPoint:(CGPoint)point
{
    //设置字体大小
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIColor *redColor = [UIColor redColor];
    //设置文本字体属性
    NSDictionary *dic = @{NSFontAttributeName: font,NSForegroundColorAttributeName:redColor};
    [text drawAtPoint:point withAttributes:dic];
}

#pragma mark -----------
#pragma mark CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _lindex++;
    if (_lindex == [self.allPoints count]) {
        _lindex = 0;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        return;
    }
    [self showLinesAnimationBegin];
}

@end
