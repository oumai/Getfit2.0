//
//  CameraController.m
//  AJBracelet
//
//  Created by kinghuang on 15/8/18.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "CameraController.h"
#import "ShowImagesController.h"


#define CAMERA_TOPVIEW_HEIGHT   44  //title

@interface CameraController () <UIScrollViewDelegate>


@property (nonatomic, strong) SCCaptureSessionManager *captureManager;

@property (nonatomic, strong) UIButton *cancelBtn;      // 取消拍照返回
@property (nonatomic, strong) UIButton *takePictureBtn; // 拍照
@property (nonatomic, strong) UIButton *flashLightBtn;  // 打开闪光等
@property (nonatomic, strong) UIButton *cameraTypeBtn;  // 选择照相机,前后摄像头
@property (nonatomic, strong) UIButton *takedImage;  // 已经拍到的照片
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UIButton *testButton2;
@property (nonatomic, strong) UILabel *testLabel;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *albumName;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) BOOL isEnable;
@property (nonatomic,strong) UIImage *takeImageLast;
@end

@implementation CameraController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self createGroupSelf];

    [self performSelector:@selector(setPhotoControl) withObject:nil afterDelay:0.2];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UserInfoHelper sharedInstance]sendPhotoControl:NO];
    [[BLTAcceptModel sharedInstance]setBLTControlTDelegate:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = KK_BgColor;
    self.navBarView.hidden = YES;
    
    [self loadCameraView];
    [self loadUpButtons];
    [self loadDownButtons];
   

}

- (void)setPhotoControl {
    NSLog(@"intoPhoto");
    [[UserInfoHelper sharedInstance] sendPhotoControl:YES];
    [[BLTAcceptModel sharedInstance] setBLTControlTDelegate:self];
  
}

- (void)bltControlTakePhoto
{
    NSLog(@"isenable == %d",_isEnable);
    if (_isEnable) {
        [_captureManager takePicture:^(UIImage *stillImage)
         {
             _isEnable = NO;
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 [self saveImageToPhotoAlbum:stillImage];//存至本机
             });
             [_takedImage setBackgroundImage:stillImage forState:UIControlStateNormal];
         }];
    }
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 加载相机
- (void)loadCameraView
{
    SCCaptureSessionManager *manager = [[SCCaptureSessionManager alloc] init];
    
    //AvcaptureManager
    if (CGRectEqualToRect(_previewRect, CGRectZero))
    {
        self.previewRect = self.view.bounds;
    }
    
    [manager configureWithParentLayer:self.view previewRect:_previewRect];
    self.captureManager = manager;
    
    [_captureManager.session startRunning];
    _isEnable = YES;
}
// 加载相机上端的按钮
- (void)loadUpButtons
{
    self.flashLightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashLightBtn.frame = CGRectMake(0, 0, 40, 60);
    _flashLightBtn.center = CGPointMake(50, 60);
    [_flashLightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_flashLightBtn addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_flashLightBtn setImage:[UIImage imageNamed:@"flashing_off"] forState:UIControlStateNormal];
    [self.view addSubview:_flashLightBtn];
    
    self.cameraTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraTypeBtn.frame = CGRectMake(0, 0, 60, 60);
    _cameraTypeBtn.center = CGPointMake(self.view.width - 38, 84);
    [_cameraTypeBtn setBackgroundImage:[UIImage image:@"switch_camera"] forState:UIControlStateNormal];
    _cameraTypeBtn.center = CGPointMake(self.view.width - 50, 60);
    [_cameraTypeBtn addTarget:self action:@selector(cameraTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_cameraTypeBtn];
}

// 加载相机的下端的按钮
- (void)loadDownButtons
{
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, 0, 100, 30);
    _cancelBtn.center = CGPointMake(50, self.view.height - 60);
    [_cancelBtn setTitle:KK_Text(@"Cancel") forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    self.takePictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _takePictureBtn.frame = CGRectMake(0, 0, 60, 60);
    _takePictureBtn.center = CGPointMake(self.view.center.x, self.view.height - 63);
    [_takePictureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_takePictureBtn addTarget:self action:@selector(takeImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [_takePictureBtn setBackgroundImage:[UIImage image:@"takePicture"] forState:UIControlStateNormal];
    [self.view addSubview:_takePictureBtn];
    
    self.takedImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width/6, self.view.width/6)];
    _takedImage.center = CGPointMake(self.view.width - 40, self.view.height - 60);
    [_takedImage setBackgroundImage:[UIImage image:@"defaultImage.png"] forState:UIControlStateNormal];
    [_takedImage addTarget:self action:@selector(takedImageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_takedImage];
    //
    self.testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _testButton.frame = CGRectMake(0, 0, 80, 30);
    _testButton.center = CGPointMake(40, self.view.height - 120);
    [_testButton setTitle:KK_Text(@"开启拍照") forState:UIControlStateNormal];
    _testButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_testButton addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.testButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _testButton2.frame = CGRectMake(0, 0, 80, 30);
    _testButton2.center = CGPointMake(40 + 120, self.view.height - 120);
    [_testButton2 setTitle:KK_Text(@"关闭拍照") forState:UIControlStateNormal];
    _testButton2.titleLabel.font = [UIFont systemFontOfSize:17];
    [_testButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_testButton2 addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    if(ISTESTMODEL) {
        [self.view addSubview:_testButton];
        [self.view addSubview:_testButton2];
    }
}
////取消拍照返回
- (void)cancelBtnClick:(UIButton *)sender
{
    if (_ifSaveImageToLocal) {
        [[UserInfoHelper sharedInstance] sendPhotoControl:NO];
        [[BLTAcceptModel sharedInstance] setBLTControlTDelegate:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}


/////拍照
- (void)takeImageClick:(UIButton *)sender
{
    [self bltControlTakePhoto];
}

//拍照页面，切换前后摄像头按钮按钮
- (void)cameraTypeBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    [_captureManager switchCamera:sender.selected];
}

//拍照页面，闪光灯按钮
- (void)flashBtnClick:(UIButton*)sender
{
    [_captureManager switchFlashMode:sender];
}

- (void)createGroupSelf {
    
    __block NSString *urlSting;
    
    self.imageArray = [[NSMutableArray alloc] init];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            _albumName =[group valueForProperty:ALAssetsGroupPropertyName];  ///获取相册的名称
            if ([_albumName isEqualToString:@"Camera Roll"] || [_albumName isEqualToString:KK_Text(@"相机胶卷")]) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        urlSting = [[[result defaultRepresentation] url] description];
                            [_imageArray addObject:urlSting];
                    }
                }];
            }
        }
        
        if (_imageArray.count != 0) {
            NSURL *url = [NSURL URLWithString:_imageArray.lastObject];
            [assetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                [_takedImage setBackgroundImage:[UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage] forState:UIControlStateNormal];
            } failureBlock:^(NSError *error) {
            }];
        }
    };
    
  
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:listGroupBlock failureBlock:nil];
}

//保存照片至本机
- (void)saveImageToPhotoAlbum:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"出错了!", nil) message:NSLocalizedString(@"保存失败", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        _isEnable = YES;
        NSLog(@"保存成功");
    }
}

/**
 *  zhangj
 */
- (void)takedImageClick
{
    [self createGroupSelf];  ///先去读取系统相册里的照片
    [self performSelector:@selector(getImageViewShow) withObject:nil afterDelay:0.5];
}

- (void)getImageViewShow
{
    ShowImagesController *show = [[ShowImagesController alloc] init];
    show.imagesArray = _imageArray;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:@"album"];
    show.albumPath = path;
    if (_imageArray.count == 0) {
        [show.imagesArray addObject:[_takedImage backgroundImageForState:UIControlStateNormal]];
    }
    [self presentViewController:show animated:YES completion:^{
    }];
}

- (void)testButtonClick:(UIButton *)sender
{
    if (sender == _testButton) {
        [[UserInfoHelper sharedInstance]sendPhotoControl:YES];
        SHOWMBProgressHUD(NSLocalizedString(@"开启照相", nil), nil, nil, NO, 1.0);
    } else {
        [[UserInfoHelper sharedInstance]sendPhotoControl:NO];
        SHOWMBProgressHUD(NSLocalizedString(@"关闭照相", nil), nil, nil, NO, 1.0);
    }
}

@end
