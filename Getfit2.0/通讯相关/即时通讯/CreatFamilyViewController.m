//
//  CreatFamilyViewController.m
//  StoryPlayer
//
//  Created by zhanghao on 15/12/5.
//  Copyright © 2015年 zxc. All rights reserved.
//

#import "CreatFamilyViewController.h"
@interface CreatFamilyViewController ()<UITextViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)choosePic:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *choosePicButton;
@property (weak, nonatomic) IBOutlet UITextField *familyName;
@property (weak, nonatomic) IBOutlet UITextField *familyAdress;
@property (weak, nonatomic) IBOutlet UITextView *familyRemark;
- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *shuoming;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation CreatFamilyViewController
{
    ZHVoidBlock _block;
    UIImage *_selectedImage;
}

-(void)setCreatCompleteBlock:(ZHVoidBlock)block
{
    _block = block;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_familyRemark setCornerRadiusss:4];
    _familyRemark.layer.borderWidth=1;
    _familyRemark.layer.borderColor = RGB(233, 233, 233).CGColor;
    if (_familyInfo)
    {
        [self loadUI];
    }
    // Do any additional setup after loading the view from its nib.
    
    _confirmButton.bgImageNormal = @"0enter_login_btn_normal_5@2x.png";
    _confirmButton.titleColorNormal = [UIColor whiteColor];
    _confirmButton.titleNormal = KK_Text(@"OK");
    
    self.naviTitle.text = KK_Text(@"Create group");
    
    _familyName.placeholder = KK_Text(@"Group Name");
    _familyAdress.placeholder = KK_Text(@"Address");
    _shuoming.text = KK_Text(@"Explanation");
}
-(void)loadUI
{
    NSLog(@"%@",formartStr(_familyInfo[@"head_img"]));
    [_choosePicButton setBackgroundImageWithURL:[NSURL URLWithString:formartStr(_familyInfo[@"head_img"])] forState:UIControlStateNormal];
    _familyName.text = formartStr(_familyInfo[@"title"]);
    _familyAdress.text = formartStr(_familyInfo[@"location"]);
    _familyRemark.text = formartStr(_familyInfo[@"description"]);
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _shuoming.hidden = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        _shuoming.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
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
///选择图片
- (IBAction)choosePic:(id)sender
{
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"Logo" cancelButtonItem:[RIButtonItem itemWithLabel:KK_Text(@"Cancel")] destructiveButtonItem:nil otherButtonItems:[RIButtonItem itemWithLabel:KK_Text(@"Choose Current Photo") action:^{
        [self LocalPhoto];
    }],[RIButtonItem itemWithLabel:KK_Text(@"Take Photo") action:^{
        [self takePhoto];
    }], nil];
    [sheet showInView:self.view];
}
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else
    {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"取消选择图片");
    [picker dismissViewControllerAnimated:YES completion:Nil];
}
//完成选择图片
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [_choosePicButton setBackgroundImage:image forState:UIControlStateNormal];
        _selectedImage = image;
    }];
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* new = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    
    return new;
}
///确认创建
- (IBAction)confirm:(id)sender
{
    ASIFormDataRequest *request;
    if (_familyInfo)
    {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/family/manager/update")]];
        [request addPostValue:_familyID forKey:@"family_id"];
    }
    else
    {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REQMethod(@"/family/create")]];
    }
    
    
    [request addPostValue:G_USERTOKEN forKey:@"access_token"];
    [request addPostValue:_familyName.text forKey:@"title"];
    [request addPostValue:_familyRemark.text forKey:@"description"];
    [request addPostValue:_familyAdress.text forKey:@"location"];
    if (_selectedImage)
    {
        UIImage *image = [self imageWithImage:_selectedImage scaledToSize:CGSizeMake(480, 480)];
        ///将图片转换成2进制文件，以JPG格式转
        NSData *zipFileData = UIImageJPEGRepresentation(image,0.9);
        if (!zipFileData)
        {
            ///如果以JPG格式转换失败，那么强制转换为PNG
            zipFileData = UIImagePNGRepresentation(image);
            [request addData:zipFileData withFileName:@"uploadImage.png" andContentType:@"image/png" forKey:@"image"];
        }
        else
        {
            [request addData:zipFileData withFileName:@"uploadImage.jpg" andContentType:@"image/jpg" forKey:@"image"];
        }
    }
    
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        [SVProgressHUD dismiss];
        ZHDEBUG(weakRequest.responseString);
        NSDictionary *dic= weakRequest.responseString.JSONValue;
        if (formartStr(dic[@"ret"]).intValue !=0 && formartStr(dic[@"ret"]))
        {
            [self showMessage:formartStr(dic[@"ret"]).intValue];
            return;
        }
        else
        {
            // NSDictionary *data = dic[@"data"];
            
            SHOWMBProgressHUD(KK_Text(@"Creating Success"), nil, nil, NO, 2.0);
            [self.navigationController popViewControllerAnimated:YES];
            
            //do something
            if (_block)
            {
                _block();
            }
            
        }
    }];
    [request setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:KK_Text(@"Server connection failed")];
    }];
    [request setTimeOutSeconds:TimeOut];
    [request startAsynchronous];
    [SVProgressHUD show];
}

@end
