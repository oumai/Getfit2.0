//
//  ZbarImageViewController.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/7.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "ZbarImageViewController.h"

@interface ZbarImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,copy)NSString *familyID;
@property(nonatomic,copy)NSString *familyName;
@end

@implementation ZbarImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setFamilyID:(NSString *)familyID AndFamilyName:(NSString *)familyName
{
    _familyID =familyID;
    _familyName = familyName;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _imageView.image = [UIImage imageWithCIImage: [self createQRForString:[NSString stringWithFormat:@"{\"name\":\"%@\",\"id\":\"%@\"}",_familyName,_familyID]]];
    [_imageView setCenterX:screenWidth/2];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CIImage *)createQRForString:(NSString *)qrString
{
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}
///定制指定大小二维码
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
