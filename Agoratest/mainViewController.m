//
//  mainViewController.m
//  Agoratest
//
//  Created by 川何 on 16/10/11.
//  Copyright © 2016年 川何. All rights reserved.
//

#import "mainViewController.h"
#import "VideoViewController.h"
#define kColor(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kMarginH 40
#define kMarginW 30
@interface mainViewController ()
@property (strong, nonatomic) UITextField *roomNumberField;
@property (strong, nonatomic) UITextField *youUserID;
@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeUI];
    // Do any additional setup after loading the view.
}

-(void)makeUI{
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.title = @"视频认证演示程序";
//    self.navigationController.navigationItem.title =  @"视频认证演示程序";
    self.navigationItem.title =   @"演示程序(客户)";
    
    UITapGestureRecognizer *gap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.view addGestureRecognizer:gap];
    
    CGFloat height = 44;
    CGFloat wight = kScreenW - 2*kMarginW;
    CGFloat heightMe = 50;
    self.youUserID = [[UITextField alloc]initWithFrame:CGRectMake(kMarginW, kMarginH + 64, wight, heightMe)];
    
    self.roomNumberField = [[UITextField alloc]initWithFrame:CGRectMake(kMarginW, 2*kMarginH + height + 24, wight, heightMe)];
    UIButton *begainConnect = [[UIButton alloc]initWithFrame:CGRectMake(kMarginW, 3*kMarginH +height * 2 + 20 , wight, heightMe)];
    
    self.youUserID.placeholder = @"请输入你的用户ID";
    self.roomNumberField.placeholder = @"输入房间号";
    self.youUserID.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.roomNumberField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [begainConnect setTitle:@"连接..." forState:UIControlStateNormal];
    begainConnect.titleLabel.font = [UIFont systemFontOfSize:26];
    [begainConnect setBackgroundColor:[UIColor greenColor]];
    [begainConnect addTarget:self action:@selector(conneectOnLine) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.youUserID];
    [self.view addSubview:self.roomNumberField];
    [self.view addSubview:begainConnect];
    
    
}
-(void)hide{
    [self.youUserID resignFirstResponder];
    [self.roomNumberField resignFirstResponder];
    
}
-(void)conneectOnLine{
    [self hide];
    
//    [self getRoomFromSevr];
    
    
    VideoViewController *vdo = [[VideoViewController alloc]init];
    vdo.view.backgroundColor = kColor(102, 102, 102);
    vdo.userID =  self.youUserID.text;
    vdo.roomNumber = self.roomNumberField.text;
    vdo.vendorKey = @"你的声网账号下的项目id";//public
//    vdo.vendorKey = @"9f53f0cd7f184634a69c0e2ef1dfcbcd";//可以录制
    [self.navigationController pushViewController:vdo animated:YES];
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
