//
//  VideoViewController.m
//  Agoratest
//
//  Created by 川何 on 16/10/11.
//  Copyright © 2016年 川何. All rights reserved.
//

#import "VideoViewController.h"
#import "ZXPAutoLayout.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kColor(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#define RecSever @"123.57.232.120:8765"
@interface VideoViewController ()<AgoraRtcEngineDelegate>

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) UIView *videoMainView;
@property (strong, nonatomic) UIView *remotoView;

@property (strong,nonatomic) UILabel *connectLable;
@property (strong,nonatomic) UIImageView *pongimage;
@property (strong,nonatomic)UIButton *RecButton;

@end

@implementation VideoViewController

//-(instancetype)init{
//    if (!self) {
//        self = [super init];
//
//
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频认证";
    [self makeupUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self makeTT];
    [self connect];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hangupAction];

}

//-(void)makeTT{
////    self.vendorKey = @"62d4943fb7404bc6a6f10dc2ce828ee6";
//    
//}

-(void)connect{
//        self.videoMainView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2.0   , kScreenH - kScreenW/2.0 , kScreenW/2.0 , kScreenW/2.0 )];
        
        [self initAgoraKit];
        [self joinChannel];
}

- (void)initAgoraKit
{
    // use test key
    //self.agoraKit = [AgoraRtcEngineKit sharedEngineWithVendorKey:self.vendorKey delegate:self];
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.vendorKey delegate:self];
    
    [self setUpVideo];
    //    [self setUpBlocks];
}

- (void)setUpVideo
{
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = [_userID intValue];
    videoCanvas.view = self.remotoView;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
}

- (void)joinChannel
{
    __weak typeof(self) weakSelf = self;
    [self.agoraKit joinChannelByKey:nil channelName:_roomNumber info:nil uid:[_userID intValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        
        [weakSelf.agoraKit setEnableSpeakerphone:YES];
        
        NSLog(@"-------------------------------进入频道成功y");
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
    }];
}


#pragma -mark delegate AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"local video display");
    __weak typeof(self) weakSelf = self;
    weakSelf.videoMainView.frame = weakSelf.videoMainView.superview.bounds; // video view's autolayout cause crash
    NSLog(@"-------------------------------本地第一针y");
    
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    __weak typeof(self) weakSelf = self;
    NSLog(@"self: %@", weakSelf);
    NSLog(@"engine: %@", engine);
    NSLog(@"---------------------------------用户加入了y");
    
    
    
}
-(void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoFrameOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    NSLog(@"-------------------------------得到远端视频第一针y");
    
}

//接通以后显示的操作

-(void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed{
    NSLog(@"-------------------------------解码回调y");
   
//    self.remotoView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2.0   , kScreenH - kScreenW/2.0 , kScreenW/2.0 , kScreenW/2.0 )];
//    self.remotoView.backgroundColor = kColor(102, 102, 102);
    AgoraRtcVideoCanvas *videoCanvas1 = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas1.uid = uid;
    videoCanvas1.view = self.videoMainView;
    videoCanvas1.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupRemoteVideo:videoCanvas1];
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = [_userID intValue];
    videoCanvas.view = self.remotoView;
    videoCanvas.renderMode = AgoraRtc_Render_Hidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
    
    self.pongimage.hidden = YES;
    self.connectLable.hidden = YES;
    
//    [self makehangupUI];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason{
    
    [self hangupAction];
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didApiCallExecute:(NSString*)api error:(NSInteger)error{
    
    NSLog(@"---录制回调-------------------------------%@------------------------录制回到------",api) ;
    
}
#pragma -mark
-(void)makehangupUI{
    UIButton *hangupButton = [[UIButton alloc]initWithFrame:CGRectMake(40, kScreenH - 60, 80, 40)];
    [hangupButton setBackgroundColor:[UIColor redColor]];
    [hangupButton setTitle:@"挂断电话" forState:UIControlStateNormal];
    [hangupButton setTintColor:[UIColor whiteColor]];
    hangupButton.titleLabel.font = [UIFont systemFontOfSize:18];
    hangupButton.layer.cornerRadius = 8.0;
    [hangupButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.videoMainView addSubview:hangupButton];
    
    _RecButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 80 - 40, kScreenH - 60, 80, 40)];
    [_RecButton setBackgroundColor:[UIColor redColor]];
    [_RecButton setTitle:@"开始录制" forState:UIControlStateNormal];
    [_RecButton setTintColor:[UIColor whiteColor]];
    _RecButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _RecButton.layer.cornerRadius = 8.0;
    [_RecButton addTarget:self action:@selector(RecAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.videoMainView addSubview:_RecButton];
    
}

-(void)hangupAction{
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        NSLog(@"-----------------------挂断成功--------------------");
//        [self.videoMainView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//-(void)RecAction{
//    if ([_RecButton.titleLabel.text isEqualToString:@"开始录制"]) {
//        [self.agoraKit startRecordingService:RecSever];
//        [_RecButton setTitle:@"录制中..." forState:UIControlStateNormal];
//
//    }else{
//        [self.agoraKit stopRecordingService:RecSever];
//        [_RecButton setTitle:@"开始录制" forState:UIControlStateNormal];
//
//    }
//
//}

-(void)makeupUI{
   
    self.videoMainView = [[UIView alloc]initWithFrame:CGRectMake(0 , 64, kScreenW  , kScreenW - 64)];
    self.videoMainView.backgroundColor = kColor(102, 102, 102);
    [self.view addSubview:_videoMainView];
    
    self.remotoView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2.0   , kScreenH - kScreenW/2.0 /3.0 *4.0 , kScreenW/2.0 , kScreenW/2.0 /3.0 *4.0)];
    [self.view addSubview:_remotoView];
    
    self.pongimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_接通中"]];
    self.pongimage.frame = CGRectMake((kScreenW - 64)/2.0, 105, 64, 64);
    [self.view addSubview:self.pongimage];
    
    self.connectLable = [[UILabel alloc]init];
    self.connectLable.text = @"视频连接中.......";
    [self.view addSubview:self.connectLable];
    [self.connectLable zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.xCenterByView(self.view,0);
        layout.topSpaceByView(self.pongimage,20);
    }];
    
    
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

@end
