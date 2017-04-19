//
//  TestViewController.m
//  AJBracelet
//
//  Created by kinghuang on 15/8/21.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

+ (TestViewController *)shareInstance {
    static TestViewController *instance = nil;
    if (instance == nil) {
        instance = [[TestViewController alloc] init];
    }
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.bleDetailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 100)];
        self.bleDetailTextView2 = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, self.view.height - 300)];
        self.view = _bleDetailTextView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)updateLog:(NSString *)s
{
//    NSData* xmlData = [s dataUsingEncoding:NSUTF8StringEncoding];
//    [[UserInfoHelper sharedInstance]writeDataToFile:xmlData className:@"sendData" fileType:@"发送数据"];
//    
//    static unsigned int count = 0;
//    [_bleDetailTextView setText:[NSString stringWithFormat:@"\n[%d]%@  %@\r\n%@",count,[[NSDate date] dateToString],s,_bleDetailTextView.text]];
//    count++;
}

-(void)updateLog2:(NSString *)s
{
    static unsigned int count = 0;
    [_bleDetailTextView2 setText:[NSString stringWithFormat:@"\n[%d]%@  %@\r\n%@",count,[[NSDate date] dateToString],s,_bleDetailTextView2.text]];
    count++;
}


@end
