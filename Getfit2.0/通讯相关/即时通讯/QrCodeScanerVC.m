//
//  QrCodeScanerVC.m
//  ChildrenBracelet
//
//  Created by zorro on 15/8/28.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

// 013148007398375

#import "QrCodeScanerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ZXingObjC.h"

@interface QrCodeScanerVC () <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;                 //捕捉会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;    //预览图层layer
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL upOrdown;
@property (nonatomic, assign) NSInteger aniNumber;;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIButton *scanImageButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIButton *openTorchButton;//扫描识别框

@property (nonatomic, strong) NSObjectSimpleBlock backBlock;

@end

@implementation QrCodeScanerVC

- (instancetype)initWithBlock:(NSObjectSimpleBlock)backBlock
{
    self = [super init];
    if (self)
    {
        _backBlock = backBlock;
    }
    
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopTimer];
    [self stopScanner];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = KK_Text(@"Scan QR code");
    self.navigationController.navigationBar.hidden = YES;
    
    [self startScan];
    [self loadBackButton];
    [self loadBottomView];
}

- (void)loadBackButton
{
    UIButton *button = [UIButton simpleWithRect:CGRectMake(0, 20, 44, 44)
                                      withImage:@"back_5s@2x.png"
                                withSelectImage:@"back_5s@2x.png"];
    [button addTouchUpTarget:self action:@selector(clickBackButton)];
    [self.view addSubview:button];
}

- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:_bottomView];
    
    _lightButton = [UIButton simpleWithRect:CGRectMake(20, 3, 44, 44)
                                      withImage:@"闪光关@2x.png"
                                withSelectImage:@"闪光开@2x.png"];
    [_lightButton addTouchUpTarget:self action:@selector(openTorchButtonTouched:)];
    [_bottomView addSubview:_lightButton];
    _lightButton.backgroundColor = [UIColor clearColor];
    
    _scanImageButton = [UIButton simpleWithRect:CGRectMake(self.view.width - 64, 3, 44, 44)
                                      withImage:@"相册@2x.png"
                                withSelectImage:@"相册@2x.png"];
    [_scanImageButton addTouchUpTarget:self action:@selector(photoPickBtn:)];
    [_bottomView addSubview:_scanImageButton];
    _scanImageButton.backgroundColor = [UIColor clearColor];
}

- (void)startScan
{
    _aniNumber = 0;
    _upOrdown = NO;
    
    //初始化设备(摄像头)
    NSError *error = nil;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error)
    {
        NSLog(@"没有摄像头:%@", error.localizedDescription);
        return;
    }
    
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //实例化捕捉会话并添加输入,输出流
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    
    //高质量采集率
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_captureSession addInput:input];
    [_captureSession addOutput:output];
    
    //设置输出的代理,在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];   //用串行队列新线程结果在UI上显示较慢
    
    //扫码类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //添加预览图层
    _videoPreviewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    //扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(60, 100, self.view.width - 120, self.view.width - 120)];
    _boxView.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    _boxView.imageNamed = @"pick_bg@2x.png";
    [self.view addSubview:_boxView];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(30, 10, _boxView.width - 60, 2)];
    _line.imageNamed = @"line@2x.png";
    [_boxView addSubview:_line];
    
    UILabel *tip = [UILabel simpleWithRect:CGRectMake(60, _boxView.totalHeight + 25, self.view.width - 120, 40)
                             withAlignment:NSTextAlignmentCenter
                              withFontSize:17
                                  withText:KK_Text(@"Alignment of QR code, \n it can automatically scan")
                             withTextColor:[UIColor whiteColor]];
    tip.numberOfLines = 2;
    [self.view addSubview:tip];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                              target:self
                                            selector:@selector(animationLine)
                                            userInfo:nil
                                             repeats:YES];
    
    //扫描识别范围
    /*
    output.rectOfInterest = CGRectMake(100 / self.view.bounds.size.height,
                                       60  / self.view.bounds.size.width,
                                       200 / self.view.bounds.size.height,
                                       200 / self.view.bounds.size.width);
     */
    
    CGSize size = self.view.bounds.size;
    CGRect cropRect = _boxView.frame;
    CGFloat p1 = size.height / size.width;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    if (p1 < p2)
    {
        CGFloat fixHeight = self.view.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding) / fixHeight,
                                            cropRect.origin.x / size.width,
                                            cropRect.size.height / fixHeight,
                                            cropRect.size.width / size.width);
    }
    else
    {
        CGFloat fixWidth = self.view.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        output.rectOfInterest = CGRectMake(cropRect.origin.y / size.height,
                                           (cropRect.origin.x + fixPadding) / fixWidth,
                                            cropRect.size.height / size.height,
                                            cropRect.size.width / fixWidth);
    }
    
    //开始扫描
    [_captureSession startRunning];
}

- (void)stopScanner
{
    [self openLight:NO];
    
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

-(void)animationLine
{
    if (_upOrdown == NO)
    {
        _aniNumber ++;
        _line.frame = CGRectMake(30, 10 + 2 * _aniNumber, _boxView.width - 60, 2);
        
        if (2 * _aniNumber == _boxView.height - 20)
        {
            _upOrdown = YES;
        }
    }
    else
    {
        _aniNumber --;
        _line.frame = CGRectMake(30, 10 + 2 * _aniNumber, _boxView.width - 60, 2);
        
        if (_aniNumber == 0)
        {
            _upOrdown = NO;
        }
    }
}

- (void)resetStateForLine
{
    [self stopTimer];
    
    _line.frame = CGRectMake(30, 10, _boxView.width - 60, 2);
    _aniNumber = 0;
    _upOrdown = NO;
}

- (void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 扫描结果代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [_captureSession stopRunning];
    //    [_videoPreviewLayer removeFromSuperlayer];
    
    if (metadataObjects.count > 0)
    {
        [self playBeep];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
            // 扫描成功
        NSLog(@"扫码扫描结果obj.stringValue == %@", obj.stringValue);
        
        if (_backBlock)
        {
            _backBlock(obj.stringValue);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 选择本地图片
- (void)photoPickBtn:(UIButton *)sender
{
    [_captureSession stopRunning];
    
    if (!_imagePickerController)
    {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma - mark - UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self resetStateForLine];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];

        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self getInfoWithImage:image];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self resetStateForLine];

    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}

#pragma mark 照片处理

-(void)getInfoWithImage:(UIImage *)img
{
    UIImage *loadImage= img;
    CGImageRef imageToDecode = loadImage.CGImage;
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    
    if (result)
    {
        NSString *contents = result.text;
        [self showInfoWithMessage:contents andTitle:KK_Text(@"Scan success")];
        NSLog(@"相册图片contents == %@",contents);
    }
    else
    {
        [self showInfoWithMessage:nil andTitle:KK_Text(@"Scan fails")];
    }
    
    if (_backBlock)
    {
        _backBlock(result);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showInfoWithMessage:(NSString *)message andTitle:(NSString *)title
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:KK_Text(@"OK")
                                          otherButtonTitles:nil];
    [alter show];
    
}

//扫描震动
- (void)playBeep
{
    SystemSoundID soundID;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep"ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//闪光灯
- (BOOL)isLightOpened
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch])
    {
        return NO;
    }
    else
    {
        if ([device torchMode] == AVCaptureTorchModeOn)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

- (void)openLight:(BOOL)open
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; // [self.reader.readerView device];
    
    if (![device hasTorch])
    {
    }
    else
    {
        if (open)
        {
            // 开启闪光灯
            if(device.torchMode != AVCaptureTorchModeOn ||
               device.flashMode != AVCaptureFlashModeOn)
            {
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                [device unlockForConfiguration];
            }
        }
        else
        {
            // 关闭闪光灯
            if(device.torchMode != AVCaptureTorchModeOff ||
               device.flashMode != AVCaptureFlashModeOff)
            {
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                [device unlockForConfiguration];
            }
        }
    }
}

// 是否开启闪光灯
- (void)openTorchButtonTouched:(UIButton *)sender
{
    UIButton *torchBtn = sender;
    torchBtn.selected = !torchBtn.selected;
    BOOL isLightOpened = [self isLightOpened];
    
    if (isLightOpened)
    {
        // [torchBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scan_flash_closed" ofType:@"png"]] forState:UIControlStateNormal];
        [torchBtn setBackgroundColor:[UIColor clearColor]];
        [torchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.openTorchButton setTitle:@"开灯" forState:UIControlStateNormal];
    }
    else
    {
        //  [torchBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scan_flash_opened" ofType:@"png"]] forState:UIControlStateNormal];
        [torchBtn setBackgroundColor:[UIColor clearColor]];
        [torchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.openTorchButton setTitle:@"关灯" forState:UIControlStateNormal];
    }
    
    [self openLight:!isLightOpened];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
