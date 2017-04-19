#import "UIViewAdditions.h"


@implementation UIView (TTCategory)

- (BOOL)visible{
	return !self.hidden;
}

- (void)setVisible:(BOOL)visible{
	self.hidden = !visible;
}

- (CGFloat)left {
  return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)top {
  return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}

- (CGFloat)centerX {
  return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
  return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (CGFloat)screenX {
  CGFloat x = 0;
  for (UIView* view = self; view; view = view.superview) {
    x += view.left;
  }
  return x;
}

- (CGFloat)screenY {
  CGFloat y = 0;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;
  }
  return y;
}

- (CGFloat)screenViewX {
  CGFloat x = 0;
  for (UIView* view = self; view; view = view.superview) {
      x += view.left;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      x -= scrollView.contentOffset.x;
    }
  }
  
  return x;
}

- (CGFloat)screenViewY {
  CGFloat y = 0;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      y -= scrollView.contentOffset.y;
    }
  }
  return y;
}

- (CGRect)screenFrame {
  return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
  return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}

- (CGSize)size {
  return self.frame.size;
}

- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}

- (CGPoint)offsetFromView:(UIView*)otherView {
  CGFloat x = 0, y = 0;
  for (UIView* view = self; view && view != otherView; view = view.superview) {
    x += view.left;
    y += view.top;
  }
  return CGPointMake(x, y);
}
/*
- (CGFloat)orientationWidth {
  return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
    ? self.height : self.width;
}

- (CGFloat)orientationHeight {
  return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
    ? self.width : self.height;
}
*/
-(void)setRoundLayer
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width/2;
}
-(void)setCornerRadiusss:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius=radius;
}


- (UIView*)descendantOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls])
    return self;
  
  for (UIView* child in self.subviews) {
    UIView* it = [child descendantOrSelfWithClass:cls];
    if (it)
      return it;
  }
  
  return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
  if ([self isKindOfClass:cls]) {
    return self;
  } else if (self.superview) {
    return [self.superview ancestorOrSelfWithClass:cls];
  } else {
    return nil;
  }
}

- (void)removeAllSubviews {
  while (self.subviews.count) {
    UIView* child = self.subviews.lastObject;
    [child removeFromSuperview];
  }
}



- (UIViewController*)viewController {
  for (UIView* next = [self superview]; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
}


- (void)addSubviews:(NSArray *)views
{
	for (UIView* v in views) {
		[self addSubview:v];
	}
}
@end

@interface NSString (ParseCategory)
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue 
outterGlue:(NSString *)outterGlue;
@end

@implementation NSString (ParseCategory)

- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue 
                                           outterGlue:(NSString *)outterGlue 
{
  NSArray *firstExplode = [self componentsSeparatedByString:outterGlue];
  NSArray *secondExplode;
  
  NSInteger count = [firstExplode count];
  NSMutableDictionary* returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
  
  for (NSInteger i = 0; i < count; i++)
  {
    secondExplode = 
    [(NSString*)[firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
    if ([secondExplode count] == 2) 
    {
      [returnDictionary setObject:[secondExplode objectAtIndex:1] 
                           forKey:[secondExplode objectAtIndex:0]];
    }
  }
  return returnDictionary;
}


@end

@implementation UIButton(ZhCategory)

-(void)setImage:(UIImage *)image inCenterAndToEdge:(CGFloat)edge
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageEdgeInsets = UIEdgeInsetsMake(edge, edge, edge, edge);
    [self setImage:image forState:UIControlStateNormal];
}

@end
@implementation UILabel(ZhCategory)

-(void)setText:(NSString *)text AutoResizeInHeight:(CGFloat)limitedHeight
{
    self.text = text;
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.width, limitedHeight) lineBreakMode:NSLineBreakByWordWrapping];
    [self setHeight:size.height];
}

@end

@implementation UITextView(ZhCategory)

-(void)setText:(NSString *)text AutoResizeInHeight:(CGFloat)limitedHeight
{
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (self.contentInset.left + self.contentInset.right
                            + self.textContainerInset.left
                            + self.textContainerInset.right
                            + self.textContainer.lineFragmentPadding/*左边距*/
                            + self.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (self.contentInset.top
                            + self.contentInset.bottom
                            + self.textContainerInset.top
                            + self.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, limitedHeight);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    CGSize calculatedSize =  [text boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);
    [self setHeight:adjustedSize.height];
}

@end



