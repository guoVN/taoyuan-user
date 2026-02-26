//
//  PGVideoCallViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/18.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGVideoCallViewController.h"
#import "PGVideoInitiationViewController.h"
#import "PGDiamondsListViewController.h"
#import "PGNavigationViewController.h"
#import "HMGiftView.h"
#import "CherryTWUser-swift.h"
#import "PGParameterSignTool.h"
//model
#import "PGMessageChatModel.h"
#import "PGMessageListModel.h"
//view
#import "PGCallRechargeView.h"
#import "HMProjectMenuView.h"
#import "HMSureHangUpAlertView.h"

@interface PGVideoCallViewController ()<AgoraRtcEngineDelegate>

@property (weak, nonatomic) IBOutlet UIView * localView;
@property (weak, nonatomic) IBOutlet UIImageView * remoteView;
@property (nonatomic, strong) AgoraRtcEngineKit * rtcKit;
@property (weak, nonatomic) IBOutlet QMUIButton *cameraSwitchBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *hangSenderBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *miantiBtn;
@property (nonatomic, strong) PGVideoInitiationViewController * vc;
@property (nonatomic, strong) AgoraRtcChannelMediaOptions * options;
@property (nonatomic, strong) AgoraRtcVideoCanvas * localVideoCanvas;

@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (nonatomic, assign) BOOL isGoRecharge;

@property (nonatomic, copy) NSString * callId;
@property (nonatomic, strong) NSTimer * chargingTimer;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic) NSInteger hours;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) NSInteger seconds;
@property (nonatomic) NSInteger realSeconds;

@end

@implementation PGVideoCallViewController

- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self rtcDestory];
    [self endBusy];
}
- (void)rtcDestory
{
    if (self.isGoRecharge) {
        return;
    }
    [self pauseTimer];
    [self.rtcKit disableAudio];
    [self.rtcKit disableVideo];
    [self.rtcKit stopPreview];
    [self.rtcKit leaveChannel:nil];
    [AgoraRtcEngineKit destroy];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self startBusy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCallTimeAction:) name:@"updateMsgCallTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherCloseCall:) name:@"otherCloseCall" object:nil];
}
- (void)loadUI
{
    WeakSelf(self)
    self.naviView.backBtn.alpha = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.rechargeView yd_setHorizentalGradualFromColor:HEX(#E5856F) toColor:HEX(#E37B9B)];
        [self configRTCKit];
    });
    self.hours = 0;
    self.minutes = 0;
    self.seconds = 0;
    self.vc = [[PGVideoInitiationViewController alloc] init];
    self.vc.isAudio = self.isAudio;
    self.vc.channelId = self.channelId;
    self.vc.callType = self.callType;
    self.vc.dataDic = self.dataDic;
    self.vc.anchorName = self.anchorName;
    self.vc.anchorHeadImg = self.anchorHeadImg;
    self.vc.isVideoCard = self.isVideoCard;
    self.vc.priceModel = self.priceModel;
    self.vc.acceptVideoBlock = ^(NSInteger type) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (type == 0) {
                    [weakself sendMsgWith:@"拒绝" withType:@"拒绝"];
                    [weakself addMsgRecord:@"拒绝视频通话"];
                }else if (type == 1) {
                    [weakself joinVideo];
                }else if (type == 2){
                    [weakself sendMsgWith:@"挂断" withType:@"挂断"];
                }else if (type == 3){
                    [weakself sendMsgWith:@"取消" withType:@"取消"];
                }
            });
        });
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addChildViewController:self.vc];
        self.vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self.view addSubview:self.vc.view];
    });
    self.callId = [PGUtils getCurrentTimeStamp];
    [PGManager shareModel].currentCallChannelId = self.channelId;
}
- (void)configRTCKit
{
    AgoraRtcEngineConfig *config = [[AgoraRtcEngineConfig alloc] init];
    config.appId = AgroaAppidRTC_Use;
    config.channelProfile = AgoraChannelProfileLiveBroadcasting;
    
    self.rtcKit = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];
    // make myself a broadcaster
    [self.rtcKit setClientRole:(AgoraClientRoleBroadcaster)];
    // enable video module and set up video encoding configs
    if (self.callType == 3) {
        [self.rtcKit enableAudio];
        [self.rtcKit enableVideo];
    }
    if (self.isAudio) {
        [self.rtcKit disableVideo];
        self.cameraSwitchBtn.alpha = 0;
        self.miantiBtn.alpha = 1;
    }
    
    AgoraVideoEncoderConfiguration *encoderConfig = [[AgoraVideoEncoderConfiguration alloc] initWithSize:CGSizeMake(960, 540) frameRate:(AgoraVideoFrameRateFps15) bitrate:15 orientationMode:(AgoraVideoOutputOrientationModeFixedPortrait) mirrorMode:(AgoraVideoMirrorModeAuto)];
    [self.rtcKit setVideoEncoderConfiguration:encoderConfig];
    
    // set up local video to render your local camera preview
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    // the view to be binded
    videoCanvas.view = self.localView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    self.localVideoCanvas = videoCanvas;
    [self.rtcKit setupLocalVideo:videoCanvas];
    // you have to call startPreview to see local video
    [self.rtcKit startPreview];
    
    // Set audio route to speaker
    [self.rtcKit setEnableSpeakerphone:YES];
    
    // start joining channel
    // 1. Users can only see each other after they join the
    // same channel successfully using the same app id.
    // 2. If app certificate is turned on at dashboard, token is needed
    // when joining channel. The channel name and uid used to calculate
    // the token has to match the ones used for channel join
    AgoraRtcChannelMediaOptions *options = [[AgoraRtcChannelMediaOptions alloc] init];
    options.autoSubscribeAudio = YES;
    options.autoSubscribeVideo = YES;
    options.publishCameraTrack = YES;
    options.publishMicrophoneTrack = YES;
    options.clientRoleType = AgoraClientRoleBroadcaster;
    self.options = options;
    
//    [[NetworkManager shared] generateTokenWithChannelName:channelName uid:0 success:^(NSString * _Nullable token) {
//        int result = [self.rtcKit joinChannelByToken:token channelId:channelName uid:0 mediaOptions:options joinSuccess:nil];
//        if (result != 0) {
//            // Usually happens with invalid parameters
//            // Error code description can be found at:
//            // en: https://api-ref.agora.io/en/video-sdk/ios/4.x/documentation/agorartckit/agoraerrorcode
//            // cn: https://doc.shengwang.cn/api-ref/rtc/ios/error-code
//            NSLog(@"joinChannel call failed: %d, please check your params", result);
//        }
//    }];
    if (self.callType == 1) {
        [self.rtcKit joinChannelByToken:@"" channelId:[PGManager shareModel].userInfo.userid uid:0 mediaOptions:options joinSuccess:nil];
    }
}
- (void)joinVideo
{
    [self.rtcKit joinChannelByToken:@"" channelId:self.channelId uid:0 mediaOptions:self.options joinSuccess:nil];
}
///对方取消或拒绝
- (void)otherCloseCall:(NSNotification *)noti
{
    [self.vc timeInvalidate];
    [self endBusy];
    [[PGUtils getCurrentVC] dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark===主动挂断
- (IBAction)hangUpAction:(QMUIButton *)sender {
    WeakSelf(self)
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonZoomInCombin)
        .wHideAnimationSet(AninatonZoomOut)
        .wShadowCanTapSet(YES)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMSureHangUpAlertView *view = [[HMSureHangUpAlertView alloc] initWithFrame:CGRectMake(0, 0, 305, 193) superView:mainView];
                view.sureHangUpBlock = ^{
                    [weakself doHangUp];
                };
                return view;
            })
        .wStart();
}
- (void)doHangUp
{
    self.hangSenderBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hangSenderBtn.selected = YES;
    });
    if (self.realSeconds < [PGManager shareModel].videoFirstRecharTime) {
        [self chargingMethod];
    }
    [self videoFinish];
    [self rtcDestory];
}
- (IBAction)cameraSwitchAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = HEX(#18C912);
        [self.rtcKit enableLocalVideo:NO];
    }else{
        sender.backgroundColor = HEX(#C4C4C4);
        [self.rtcKit enableLocalVideo:YES];
    }
}
- (IBAction)chooseGiftAction:(id)sender {
    WeakSelf(self)
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonCurverOn)
        .wHideAnimationSet(AninatonCurverOff)
        .wPointSet(CGPointMake(0, ScreenHeight-332-SafeBottom))
        .wShadowCanTapSet(YES)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMGiftView *view = [[HMGiftView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 332+SafeBottom) superView:mainView];
                view.channelId = self.channelId;
                view.sendGiftBlock = ^(NSString * _Nonnull giftName) {
                    [weakself sendMsgWith:giftName withType:@"礼物"];
                    [weakself addMsgRecord:[NSString stringWithFormat:@"送出礼物%@",giftName]];
                };
                return view;
            })
        .wStart();
}
- (IBAction)checkMeunAction:(id)sender {
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonZoomInCombin)
        .wHideAnimationSet(AninatonZoomOut)
        .wShadowCanTapSet(YES)
        .wPointSet(CGPointMake(ScreenWidth-207-9, ScreenHeight-SafeBottom-348-52-7))
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMProjectMenuView *view = [[HMProjectMenuView alloc] initWithFrame:CGRectMake(0, 0, 207, 348) superView:mainView];
                
                return view;
            })
        .wStart();
}
- (IBAction)miantiBtnAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    [self.rtcKit setEnableSpeakerphone:sender.selected];
}
#pragma mark===发送消息
- (void)sendMsgWith:(NSString *)sendContent withType:(NSString *)type
{
    if (self.channelId.length == 0) {
        return;
    }
    NSDictionary * dic = @{@"type":type,@"content":sendContent,@"address":@"",@"anchorId":self.channelId,@"bindId":@"",@"friendId":self.channelId,@"isRecharge":@"",@"senderName":[PGManager shareModel].userInfo.nickName,@"senderPhoto":[PGManager shareModel].userInfo.photo,@"senderid":[PGManager shareModel].userInfo.userid,@"state":@""};
    NSString * msgStr = [PGUtils objectToJson:dic];
    WeakSelf(self)
    AgoraChatTextMessageBody *textMessageBody = [[AgoraChatTextMessageBody alloc] initWithText:msgStr];
    // 消息接收方，单聊为对端用户的 ID，群聊为群组 ID，聊天室为聊天室 ID。
    NSString* conversationId = self.channelId;
    [self dealMsg:type];
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:conversationId
                                                          body:textMessageBody
                                                                   ext:nil];
    message.ext = @{@"em_apns_ext":@{
        @"em_push_title": [PGManager shareModel].userInfo.nickName,
        @"em_push_content": [type isEqualToString:@"文字"] ? sendContent : [NSString stringWithFormat:@"[%@]",type]
    }};
    // 会话类型，单聊为 `AgoraChatTypeChat`，群聊为 `AgoraChatTypeGroupChat`，聊天室为 `AgoraChatTypeChatRoom`，默认为单聊。
    message.chatType = AgoraChatTypeChat;
    // 发送消息。
    [[AgoraChatClient sharedClient].chatManager sendMessage:message
                                            progress:nil
                                                 completion:^(AgoraChatMessage * _Nullable message, AgoraChatError * _Nullable error) {
        if (!error) {
            if ([type isEqualToString:@"挂断"]) {
                [weakself updateCallTime:dic message:message];
            }else if ([type isEqualToString:@"接收"]){
                AgoraChatConversation *conversation = [AgoraChatClient.sharedClient.chatManager getConversationWithConvId:self.channelId];
                AgoraChatError *error;
                [conversation deleteMessageWithId:message.messageId error:&error];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgContent" object:nil userInfo:@{@"msg":message}];
            }
            [weakself addMsgRecord:sendContent];
        }
    }];
}
///处理消息
- (void)dealMsg:(NSString *)type
{
    if ([type isEqualToString:@"取消"] || [type isEqualToString:@"拒绝"] || [type isEqualToString:@"挂断"]) {
        AgoraChatConversation *conversation = [AgoraChatClient.sharedClient.chatManager getConversationWithConvId:self.channelId];
        AgoraChatError *error;
        [conversation deleteMessageWithId:[PGManager shareModel].currentCallMsgId error:&error];
    }
}
- (void)updateCallTimeAction:(NSNotification *)noti
{
    NSDictionary * dic = noti.userInfo;
    NSDictionary * dataDic = dic[@"data"];
    AgoraChatMessage * msg = dic[@"msg"];
    [self updateCallTime:dataDic message:msg];
}
- (void)updateCallTime:(NSDictionary *)dic message:(AgoraChatMessage *)message
{
    NSString * timeStr = self.videoTimeLabel.text;
//    if ([timeStr hasPrefix:@"00:"]) {
//        timeStr = [timeStr substringFromIndex:3];
//    }
    timeStr = [NSString stringWithFormat:@"%@:%@",Localized(@"通话时长"),timeStr];
    [[NSUserDefaults standardUserDefaults] setValue:timeStr forKey:message.messageId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgContent" object:nil userInfo:@{@"msg":message}];
    [PGManager shareModel].currentCallMsgId = @"";
    [PGManager shareModel].currentCallConversationId = @"";
}
#pragma mark===充值
- (IBAction)goRechargeAction:(id)sender {
    WeakSelf(self)
    self.isGoRecharge = YES;
    PGCallRechargeView * rechargeView = [[PGCallRechargeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    PGDiamondsListViewController * vc = [[PGDiamondsListViewController alloc] init];
    vc.isCallRecharge = YES;
    PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
    nav.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-200);
    [nav.view acs_radiusWithRadius:18 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    [rechargeView.backView addSubview:nav.view];
    [rechargeView.backView bringSubviewToFront:rechargeView.closeBtn];
    rechargeView.refreshCoinBlock = ^{
        [PGUtils getUserInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself showRecharge];
        });
    };
    [[UIApplication sharedApplication].delegate.window addSubview:rechargeView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isGoRecharge = NO;
    });
}
- (void)updateTimer
{
    self.realSeconds++;
    self.seconds++;
    if (self.seconds == 60) {
        self.seconds = 0;
        self.minutes++;
        if (self.minutes == 60) {
            self.minutes = 0;
            self.hours++;
        }
    }
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)self.hours, (long)self.minutes, (long)self.seconds];
    self.videoTimeLabel.text = timeString;
    if (self.realSeconds == [PGManager shareModel].videoFirstRecharTime) {
        [self chargingMethod];
    }
}
- (void)pauseTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.chargingTimer invalidate];
    self.chargingTimer = nil;
}
#pragma mark===扣费
- (void)chargingMethod
{
    if ([PGManager shareModel].selfCoin < [PGManager shareModel].callCoin) {
        [QMUITips showWithText:@"话费不足，通话中断"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hangUpAction:nil];
        });
        return;
    }
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.callId forKey:@"id"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.callType == 1 ? @"1" : @"3" forKey:@"callType"];
    [dic setValue:@"视频" forKey:@"type"];
    [dic setValue:[NSString stringWithFormat:@"%ld",[PGManager shareModel].callCoin] forKey:@"coin"];
    NSString * sign = [PGParameterSignTool encoingPameterSignWithDic:[NSMutableDictionary dictionaryWithDictionary:dic] andTimeSta:@""];
    [dic setValue:sign forKey:@"sign"];
    [dic setValue:self.channelId forKey:@"anchorUserid"];
    NSString * timeStr = self.videoTimeLabel.text;
    if ([timeStr hasPrefix:@"00:"]) {
        timeStr = [timeStr substringFromIndex:3];
    }
    [dic setValue:timeStr forKey:@"time"];
    [PGAPIService videoChargingWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        
        [PGUtils getUserInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself showRecharge];
        });
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)showRecharge
{
    if ([PGManager shareModel].selfCoin < 2*[PGManager shareModel].callCoin) {
        self.rechargeView.alpha = 1;
    }else{
        self.rechargeView.alpha = 0;
    }
}
#pragma mark===视频结束
- (void)videoFinish
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:self.channelId forKey:@"anchorId"];
    [dic setValue:self.callId forKey:@"id"];
    NSString * timeStr = self.videoTimeLabel.text;
    if ([timeStr hasPrefix:@"00:"]) {
        timeStr = [timeStr substringFromIndex:3];
    }
    [dic setValue:timeStr forKey:@"time"];
    [PGAPIService videoFinishWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself updateVideoCallTime];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [weakself updateVideoCallTime];
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)updateVideoCallTime
{
    NSString * timeStr = self.videoTimeLabel.text;
    if ([timeStr hasPrefix:@"00:"]) {
        timeStr = [timeStr substringFromIndex:3];
    }
    timeStr = [NSString stringWithFormat:@"通话时长：%@",timeStr];
    [self addMsgRecord:timeStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PGUtils getCurrentVC] dismissViewControllerAnimated:YES completion:^{
            [PGManager shareModel].isCallYes = NO;
        }];
    });
}
- (void)addMsgRecord:(NSString *)content
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.channelId forKey:@"friendid"];
    [dic setValue:content forKey:@"content"];
    [dic setValue:@"" forKey:@"virtualAnchorid"];
    [PGAPIService messageSendAddRecordWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===开启，结束忙碌
- (void)startBusy
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:self.channelId forKey:@"anchorUserId"];
    [dic setValue:@"video_voice" forKey:@"submitReason"];
    [PGAPIService startBusyStatusWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)endBusy
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:self.channelId forKey:@"anchorUserId"];
    [dic setValue:@"video_voice" forKey:@"submitReason"];
    [PGAPIService endBusyStatusWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    
}

///自己成功加入
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {

}
///对方成功加入
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    // Only one remote video view is available for this
    // tutorial. Here we check if there exists a surface
    // view tagged as this uid.
    [PGManager shareModel].isCallYes = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vc.isSelfClick = YES;
        [self.vc timeInvalidate];
        [self.vc removeNoti];
        [self.vc.view removeFromSuperview];
        [self.vc removeFromParentViewController];
        [self.rtcKit enableAudio];
        [self.rtcKit enableVideo];
        if (self.isAudio) {
            [self.rtcKit disableVideo];
            self.cameraSwitchBtn.alpha = 0;
            self.miantiBtn.alpha = 1;
        }
    });
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc]init];
    videoCanvas.uid = uid;
    // the view to be binded
    videoCanvas.view = self.remoteView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.rtcKit setupRemoteVideo:videoCanvas];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    self.chargingTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(chargingMethod) userInfo:nil repeats:YES];
}
///对方离开
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
//    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc]init];
//    videoCanvas.uid = uid;
//    // the view to be binded
//    videoCanvas.view = nil;
//    [self.agoraKit setupRemoteVideo:videoCanvas];
//    self.remoteView.uid = 0;
//    [LogUtil log:[NSString stringWithFormat:@"remote user left: %lu", uid] level:(LogLevelDebug)];
    [self videoFinish];
    [self pauseTimer];
}

- (NSString *)timeStringFromSeconds:(NSInteger)seconds {
    // 计算小时、分钟、秒
//    NSInteger hours = seconds / 3600;
    NSInteger minutes = (seconds % 3600) / 60;
    NSInteger secs = seconds % 60;
    
    // 格式化为两位数（补零）
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)secs];
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
