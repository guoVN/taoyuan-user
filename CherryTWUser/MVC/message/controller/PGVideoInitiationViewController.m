//
//  PGVideoInitiationViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/31.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGVideoInitiationViewController.h"
#import "PGParameterSignTool.h"
//model
#import "PGMessageListModel.h"
#import "PGAnchorModel.h"

@interface PGVideoInitiationViewController ()

@property (nonatomic, strong) UIView * headBackView;
@property (nonatomic, strong) NSTimer * timer;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;

@end

@implementation PGVideoInitiationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self creatAVAudioSessionObject];
    [self loadAnchorCallCoin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(anchorAction:) name:@"CallBackNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVideo) name:@"cancelRecharge" object:nil];
}
- (void)loadUI
{
    self.hangUpBtn1.alpha = self.callType == 1 ? 1 : 0;
    self.hangBtn2.alpha = self.answerBtn.alpha = self.callType == 3 ? 1 : 0;
    [self.headImg addBlurEffect:UIBlurEffectStyleLight withAlpha:0.8];
    [self.view addSubview:self.headBackView];
    [self.headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+168);
        make.width.height.mas_equalTo(74);
    }];
    [self.headBackView startRipple:37 fromValue:@1.0 toValue:@2.1];
    [self.view bringSubviewToFront:self.headImg];
    if (self.callType == 1) {
        if (self.isVideoCard) {
//            [self.bgImg sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"senderPhoto"]]];
            [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"senderPhoto"]] placeholderImage:MPImage(@"netFaild")];
        }else{
//            self.bgImg.image = self.anchorHeadImg;
            self.headImg.image = self.anchorHeadImg;
        }
    }else if (self.callType == 3) {
//        [self.bgImg sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"senderPhoto"]]];
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"senderPhoto"]] placeholderImage:MPImage(@"netFaild")];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isSelfClick) {
            if (self.callType == 1) {
                [self hangUpAction1:self.hangUpBtn1];
            }else if (self.callType == 3){
                [self hangUpAction2:self.hangBtn2];
            }
        }
    });
    [self.view addSubview:self.priceView];
    [self.priceView addSubview:self.priceLabel];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.hangUpBtn1.mas_bottom).offset(33);
        make.height.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(82);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(3);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-4);
    }];
    if (self.priceModel == nil) {
        [self loadCallPrice];
    }else{
        [self updateCallPriceWith:self.priceModel];
    }
}
- (void)updateCallPriceWith:(PGAnchorPriceModel *)model
{
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:@"/min)"];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"zuanshiLittle"];
    attach.bounds = CGRectMake(0, -4, 18, 16);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    [att insertAttributedString:attrStringWithImage atIndex:0];
    NSAttributedString * pp = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%ld",model.video/10]];
    [att insertAttributedString:pp atIndex:0];
    self.priceLabel.attributedText = att;
}
/// 创建音乐播放器
- (void)creatAVAudioSessionObject{
    //设置后台模式和锁屏模式下依然能够播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    //初始化音频播放器
    NSError *playerError;
    NSURL *urlSound = [[NSURL alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"call" ofType:@"wav"]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSound error:&playerError];
    self.audioPlayer.numberOfLoops = -1;//无限播放
    self.audioPlayer.volume = 1;
    [PGManager shareModel].audioPlayer = self.audioPlayer;
}
- (void)vibrate
{
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //音频
    [[PGManager shareModel].audioPlayer play];
}
- (void)loadCallPrice
{
    WeakSelf(self)
    [PGAPIService getCallPriceWithParameters:@{@"userid":self.channelId} Success:^(id  _Nonnull data) {
        PGAnchorPriceModel * priceModel = [PGAnchorPriceModel mj_objectWithKeyValues:data[@"data"]];
        [weakself updateCallPriceWith:priceModel];
        weakself.priceModel = priceModel;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===请求视频价格
- (void)loadAnchorCallCoin
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.channelId forKey:@"anchorid"];
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    [PGAPIService anchorDetailWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        id aa = data[@"data"];
        if ([aa isKindOfClass:[NSNull class]]) {
            [PGManager shareModel].callCoin = 0;
        }else{
            PGAnchorModel * model = [PGAnchorModel mj_objectWithKeyValues:data[@"data"]];
            [PGManager shareModel].callCoin = [model.videoCoin integerValue];
        }
        
        if (weakself.callType == 3) {
            if ([PGManager shareModel].selfCoin < [PGManager shareModel].callCoin) {
                [QMUITips showWithText:@"用户金币不足"];
                [PGUtils goRechargeAlert];
            }
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
///暂时没用到这个接口
- (void)loadSelfCallCoin
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.channelId forKey:@"anchorid"];
    [dic setValue:self.channelId forKey:@"virtualAnchorid"];
    [PGAPIService videoUserPublishWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        id aa = data[@"data"];
        if ([aa isKindOfClass:[NSNull class]]) {
            [PGManager shareModel].callCoin = 0;
        }else{
            [PGManager shareModel].callCoin = [data[@"data"] integerValue];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)cancelVideo
{
//    [self hangUpAction2:nil];
}
- (IBAction)hangUpAction1:(QMUIButton *)sender {
    [self chargingMethod];
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    self.isSelfClick = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshVideoCallType" object:nil userInfo:@{@"status":@"已取消"}];
    if (self.acceptVideoBlock) {
        self.acceptVideoBlock(2);
    }
    [self timeInvalidate];
    [[PGUtils getCurrentVC] dismissViewControllerAnimated:YES completion:^{
        [self removeNoti];
    }];
}
- (IBAction)hangUpAction2:(QMUIButton *)sender {
    [self chargingMethod];
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    self.isSelfClick = YES;
    NSString * statusStr = @"已拒绝";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshVideoCallType" object:nil userInfo:@{@"status":statusStr}];
    if (self.acceptVideoBlock) {
        self.acceptVideoBlock(0);
    }
    [self videoStatusMan:0];
    [self timeInvalidate];
    [[PGUtils getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)answerAction:(QMUIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    if ([PGManager shareModel].callCoin == 0) {
        [QMUITips showWithText:@"视频价格不能为0"];
        return;
    }
    if ([PGManager shareModel].selfCoin < [PGManager shareModel].callCoin) {
        [QMUITips showWithText:@"钻石余额不足，请充值"];
        [PGUtils goRechargeAlert];
        return;
    }
    self.isSelfClick = YES;
    [self timeInvalidate];
    if (self.acceptVideoBlock) {
        self.acceptVideoBlock(1);
    }
    [self videoStatusMan:1];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    });
}
#pragma mark===主播打来视频，男端接通或拒绝
- (void)videoStatusMan:(NSInteger )type
{
    [self removeNoti];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.channelId forKey:@"anchorid"];
    [dic setValue:@(type) forKey:@"status"];
    [PGAPIService callVideoManStatusWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===主播回应
- (void)anchorAction:(NSNotification *)noti
{
    if ([PGManager shareModel].isCallYes == YES) {
        return;
    }
    NSDictionary * dic = noti.userInfo;
    NSString * statusStr = [NSString stringWithFormat:@"对方已%@",dic[@"type"]];
    if (![statusStr containsString:@"接收"]) {
        NSLog(@"hahahaha");
        [self chargingMethod];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshVideoCallType" object:nil userInfo:@{@"status":statusStr}];
        [[PGUtils getCurrentVC] dismissViewControllerAnimated:YES completion:^{
            [self removeNoti];
        }];
    }
    self.isSelfClick = YES;
    [self timeInvalidate];
}
- (void)timeInvalidate
{
    [[PGManager shareModel].audioPlayer stop];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark===扣费
- (void)chargingMethod
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGUtils getCurrentTimeStamp] forKey:@"id"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.callType == 1 ? @"2" : @"3" forKey:@"callType"];
    [dic setValue:@"视频" forKey:@"type"];
    [dic setValue:@"0" forKey:@"coin"];
    NSString * sign = [PGParameterSignTool encoingPameterSignWithDic:[NSMutableDictionary dictionaryWithDictionary:dic] andTimeSta:@""];
    [dic setValue:sign forKey:@"sign"];
    [dic setValue:self.channelId forKey:@"anchorUserid"];
    [dic setValue:@"00:00" forKey:@"time"];
    [PGAPIService videoChargingWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
      
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)removeNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallBackNoti" object:nil];
}

- (UIView *)headBackView
{
    if (!_headBackView) {
        _headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
    }
    return _headBackView;
}
- (UIView *)priceView
{
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        _priceView.backgroundColor = HEXAlpha(#F5F5F5, 0.53f);
        [_priceView acs_radiusWithRadius:13 corner:UIRectCornerAllCorners];
    }
    return _priceView;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = MPBoldFont(13);
        _priceLabel.textColor = HEX(#FFFFFF);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
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
