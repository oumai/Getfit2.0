//
//  ShowScrollView.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/15.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShowScrollView.h"

@implementation ShowScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;

    [self loadScrollView];
}

- (void)loadScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bouncesZoom = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    CGFloat imgW = self.bounds.size.width;
    CGFloat imgH = self.bounds.size.height;
    
    CGFloat height = FitScreenNumber(44, 0, 0, 0, 0);
    
    for (int i = 0; i < _imageArray.count; i++)
    {
    NSString *imgName = [_imageArray objectAtIndex:i];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.frame = CGRectMake(i * imgW, - height, imgW, imgH );
    [_scrollView addSubview:imgView];
        
    }

     CGFloat pageHeight = FitScreenNumber(44, 44, 44, 44, 44);
    
    _scrollView.contentSize = CGSizeMake(_imageArray.count * imgW, 0);
    _scrollView.pagingEnabled = YES;
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.center = CGPointMake(imgW * 0.5, imgH - 30 - pageHeight* 0.7);
    _pageControl.bounds = CGRectMake(0, 0, 150, 15);
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.enabled = NO;
    [self addSubview:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    int curPageNo = offset.x / _scrollView.bounds.size.width;
    _pageControl.currentPage = curPageNo ;
    
}

@end
