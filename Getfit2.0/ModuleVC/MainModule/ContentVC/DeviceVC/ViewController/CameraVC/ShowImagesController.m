//
//  ShowImagesController.m
//  AJBracelet
//
//  Created by kinghuang on 15/8/29.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ShowImagesController.h"

#define WIDTHSPACE (self.view.width + 20)

@interface ShowImagesController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSFileManager      *FileManager;
@property (nonatomic,strong) NSArray            *PathArray;
@property (nonatomic,strong) UIImageView        *imageView1;
@property (nonatomic,strong) UIImageView        *imageView2;
@property (nonatomic,strong) UIImageView        *imageView3;

@property (nonatomic,assign) CGFloat     OriginOffsetX;
@property (nonatomic,assign) NSInteger   CurrentIndex;
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation ShowImagesController
{
    NSInteger index;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _FileManager = [NSFileManager defaultManager];
    
    _PathArray = [_FileManager subpathsAtPath:_albumPath];
    [self createView];
    NSLog(@"tj:%@",_albumPath);
}

#pragma mark -- 懒加载 ---

- (NSMutableArray *)imagesArray {
    if (_imagesArray == nil) {
        _imagesArray  = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}

#pragma mark --
- (void)createView {
    self.scrollerImageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTHSPACE, self.view.height)];
    self.scrollerImageView.bounces = NO;
    _scrollerImageView.delegate = self;
//    for (NSInteger i = _imagesArray.count;i > 0 ; i--) {
//         UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_imagesArray.count - i)* WIDTHSPACE, 0,self.view.width, self.view.height)];
//         imageView.image = _imagesArray[i - 1];
//         [self.scrollerImageView addSubview:imageView];
//    }
    
//    for (NSInteger i = 0;i < 3 ; i--) {
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((0)* WIDTHSPACE, 0,self.view.width, self.view.height)];
    
    
    NSURL *url1;
    if (_imagesArray.count > 0) {
        
        url1 = [NSURL URLWithString:_imagesArray[0]];
    }
    
    [_assetsLibrary assetForURL:url1 resultBlock:^(ALAsset *asset) {
        _imageView1.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
    } failureBlock:^(NSError *error) {
        
    }];

    _imageView1.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollerImageView addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((1)* WIDTHSPACE, 0,self.view.width, self.view.height)];
    
    NSURL *url2;
    NSInteger indexMaxOne = 1;
    if (_imagesArray.count > indexMaxOne) {
        
        url2 = [NSURL URLWithString:_imagesArray[_imagesArray.count - indexMaxOne]];
    }
    
    [_assetsLibrary assetForURL:url2 resultBlock:^(ALAsset *asset) {
        _imageView2.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
    } failureBlock:^(NSError *error) {
    }];

    _imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollerImageView addSubview:_imageView2];
    
    _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake((2)* WIDTHSPACE, 0,self.view.width, self.view.height)];
    
    NSURL *url3;
    NSInteger indexMaxTwo = 2;
    if (_imagesArray.count > indexMaxTwo) {
        url3 = [NSURL URLWithString:_imagesArray[_imagesArray.count - indexMaxTwo]];
    }
    
    [_assetsLibrary assetForURL:url3 resultBlock:^(ALAsset *asset) {
        _imageView3.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
    } failureBlock:^(NSError *error) {
        
    }];

    _imageView3.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollerImageView addSubview:_imageView3];
//    }
//    _scrollerImageView.contentSize = CGSizeMake(_imagesArray.count * WIDTHSPACE, self.view.height);
    _scrollerImageView.contentSize = CGSizeMake(3 * WIDTHSPACE, self.view.height);
    _scrollerImageView.contentOffset = CGPointMake((1)* WIDTHSPACE, 0);
    _OriginOffsetX = 1* WIDTHSPACE;
    _CurrentIndex = _imagesArray.count - 1;
    _scrollerImageView.pagingEnabled = YES;

    [self.view addSubview:_scrollerImageView];

    self.backToCamera = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    _backToCamera.center = CGPointMake(30, self.view.height - 60);
    [_backToCamera setTitle:KK_Text(@"Back") forState:UIControlStateNormal];
    [_backToCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backToCamera addTouchUpTarget:self action:@selector(backToCamera:)];
    [self.view addSubview:_backToCamera];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x - _OriginOffsetX > 0 ) {
        NSInteger index1 ,index2,index3;
        
        if (_CurrentIndex == 0) {
            _CurrentIndex = _imagesArray.count - 1;
            index2 = _CurrentIndex;
            index3 = index2 - 1;
            index1 = 0;
        }else if(_CurrentIndex == 1){
            index2 = --_CurrentIndex;
            index3 = _imagesArray.count - 1;
            index1 = index2 + 1;
        }else{
            index2 = --_CurrentIndex;
            index3 = index2 - 1;
            index1 = index2 + 1;
        }
        
        
        
      
        NSURL *url2 = [NSURL URLWithString:_imagesArray[index2]];
        [_assetsLibrary assetForURL:url2 resultBlock:^(ALAsset *asset) {
            _imageView2.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
            scrollView.contentOffset = CGPointMake((1)* WIDTHSPACE, 0);
        } failureBlock:^(NSError *error) {
        }];
        
        
        NSURL *url3 = [NSURL URLWithString:_imagesArray[index3]];
        [_assetsLibrary assetForURL:url3 resultBlock:^(ALAsset *asset) {
            _imageView3.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        } failureBlock:^(NSError *error) {
            
        }];
        NSURL *url1 = [NSURL URLWithString:_imagesArray[index1]];
        [_assetsLibrary assetForURL:url1 resultBlock:^(ALAsset *asset) {
            _imageView1.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }else if (scrollView.contentOffset.x - _OriginOffsetX < 0 ) {
        NSInteger index1 ,index2,index3;
        
        if (_CurrentIndex == _imagesArray.count - 1) {
            _CurrentIndex = 0;
            index2 = _CurrentIndex;
            index3 = _imagesArray.count - 1;
            index1 = 1;
        }else if(_CurrentIndex == _imagesArray.count - 2){
            index2 = ++_CurrentIndex;
            index3 = index2 -1;
            index1 = 0;
        }else{
            index2 = ++_CurrentIndex;
            index3 = index2 -1;
            index1 = index2 + 1;
        }
        
        
        NSURL *url2 = [NSURL URLWithString:_imagesArray[index2]];
        [_assetsLibrary assetForURL:url2 resultBlock:^(ALAsset *asset) {
            _imageView2.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
            scrollView.contentOffset = CGPointMake((1)* WIDTHSPACE, 0);
        } failureBlock:^(NSError *error) {
        }];
        
        
        NSURL *url3 = [NSURL URLWithString:_imagesArray[index3]];
        [_assetsLibrary assetForURL:url3 resultBlock:^(ALAsset *asset) {
            _imageView3.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        } failureBlock:^(NSError *error) {
            
        }];
        NSURL *url1 = [NSURL URLWithString:_imagesArray[index1]];
        [_assetsLibrary assetForURL:url1 resultBlock:^(ALAsset *asset) {
            _imageView1.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        } failureBlock:^(NSError *error) {
            
        }];

        
        }
}

- (void)backToCamera:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
