#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (TTCategory)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

@property(nonatomic) BOOL visible;

//设置圆
-(void)setRoundLayer;
//设置圆角
-(void)setCornerRadiusss:(CGFloat)radius;
/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;


/**
 * Calculates the offset of this view from another view in screen coordinates.
 */
- (CGPoint)offsetFromView:(UIView*)otherView;


/**
 * The view controller whose view contains this view.
 */
- (UIViewController*)viewController;


- (void)addSubviews:(NSArray *)views;

@end


@interface UIButton (ZhCategory)

//重写设置颜色然后可以有点击效果

-(void)setImage:(UIImage *)image inCenterAndToEdge:(CGFloat)edge;


@end

@interface UILabel (ZhCategory)

//自适应高度
-(void)setText:(NSString *)text AutoResizeInHeight:(CGFloat)limitedHeight;


@end


@interface UITextView (ZhCategory)

//自适应高度
-(void)setText:(NSString *)text AutoResizeInHeight:(CGFloat)limitedHeight;


@end


