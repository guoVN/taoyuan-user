//
//  PGVideoCardAlertView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/30.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGVideoCardAlertView.h"
#import "PGVideoCallViewController.h"
#import "PGNavigationViewController.h"
#import "PGAnchorModel.h"
#import "PGMessageListModel.h"

@interface PGVideoCardAlertView ()

@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, strong) NSTimer * timer;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;
@property (nonatomic, strong) PGAnchorPriceModel * priceModel;

@end

@implementation PGVideoCardAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#2A2A2A, 0.79f);
        [self initSubView];
        [self snapSubView];
        [self creatAVAudioSessionObject];
        [self startBusy];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.coverImg];
    [self.backView addSubview:self.coverView];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.headImg];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.tipsLabel];
    [self.backView addSubview:self.acceptBtn];
    [self.backView addSubview:self.priceView];
    [self.priceView addSubview:self.priceLabel];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(vibrate) userInfo:nil repeats:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isConnect) {
            [self closeBtnAction];
        }
    });
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(550);
        make.centerY.mas_equalTo(0);
    }];
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.width.height.mas_equalTo(28);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(94);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(74);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_bottom).offset(20);
        make.centerX.mas_equalTo(0);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(80);
        make.centerX.mas_equalTo(0);
    }];
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-64);
        make.size.mas_equalTo(CGSizeMake(164, 80));
        make.centerX.mas_equalTo(0);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(82);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(3);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-4);
    }];
}
/// 创建音乐播放器
- (void)creatAVAudioSessionObject{
    //设置后台模式和锁屏模式下依然能够播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    //初始化音频播放器
    NSError *playerError;
    NSURL *urlSound = [[NSURL alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"receiver" ofType:@"wav"]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSound error:&playerError];
    self.audioPlayer.numberOfLoops = -1;//无限播放
    self.audioPlayer.volume = 1;
    [PGManager shareModel].audioPlayer = self.audioPlayer;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    NSURL * headUrl = [NSURL URLWithString:dataDic[@"senderPhoto"]];
    [self.coverImg sd_setImageWithURL:headUrl placeholderImage:MPImage(@"netFaild")];
    [self.headImg sd_setImageWithURL:headUrl placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = dataDic[@"senderName"];
    [self loadCallPrice];
    [self loadAnchorCallCoin];
}
- (void)vibrate
{
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //音频
    [[PGManager shareModel].audioPlayer play];
}
- (void)closeBtnAction
{
    [self endBusy];
    [[PGManager shareModel].audioPlayer stop];
    [self refuseAction];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [PGManager shareModel].isShowVideoCard = NO;
    [self removeFromSuperview];
}
- (void)refuseAction
{
    NSString * anchorId = self.dataDic[@"senderid"];
    if (anchorId.length==0) {
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:anchorId forKey:@"anchorId"];
    [PGAPIService userRefuseVideoWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)callAction:(UIButton *)sender
{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.selected = YES;
    });
    if ([PGManager shareModel].selfCoin < [PGManager shareModel].callCoin || [PGManager shareModel].selfCoin < 100) {
        [QMUITips showWithText:@"用户金币不足"];
        [PGUtils goRechargeAlert];
        return;
    }
    [[PGManager shareModel].audioPlayer stop];
    self.isConnect = YES;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSString * senderId = [NSString stringWithFormat:@"%@",self.dataDic[@"senderid"]];
    
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:senderId forKey:@"anchorId"];
    [dic setValue:@"" forKey:@"virtualAnchorId"];
    [dic setValue:@"2" forKey:@"type"];//1-语音通话 2-视频通话 3-消息
    [PGAPIService videoCheckPreChargingWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself sendMsgWith:@"" withType:@"视频"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
    [PGManager shareModel].isShowVideoCard = NO;
    [self removeFromSuperview];
}

#pragma mark===发送消息
- (void)sendMsgWith:(NSString *)sendContent withType:(NSString *)type
{
    NSString * senderId = [NSString stringWithFormat:@"%@",self.dataDic[@"senderid"]];
    if (senderId.length == 0) {
        return;
    }
    NSDictionary * dic = @{@"type":type,@"content":sendContent,@"address":@"",@"anchorId":senderId,@"bindId":@"",@"friendId":senderId,@"isRecharge":@"",@"senderName":[PGManager shareModel].userInfo.nickName,@"senderPhoto":[PGManager shareModel].userInfo.photo,@"senderid":[PGManager shareModel].userInfo.userid,@"state":@""};
    NSString * msgStr = [PGUtils objectToJson:dic];
    WeakSelf(self)
    AgoraChatTextMessageBody *textMessageBody = [[AgoraChatTextMessageBody alloc] initWithText:msgStr];
    // 消息接收方，单聊为对端用户的 ID，群聊为群组 ID，聊天室为聊天室 ID。
    NSString* conversationId = [NSString stringWithFormat:@"%@",self.dataDic[@"senderid"]];
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:conversationId
                                                          body:textMessageBody
                                                                   ext:nil];
    message.ext = @{@"em_apns_ext":@{
        @"em_push_title": [PGManager shareModel].userInfo.nickName,
        @"em_push_content": @"[视频]"
    }};
    // 会话类型，单聊为 `AgoraChatTypeChat`，群聊为 `AgoraChatTypeGroupChat`，聊天室为 `AgoraChatTypeChatRoom`，默认为单聊。
    message.chatType = AgoraChatTypeChat;
    // 发送消息。
    [[AgoraChatClient sharedClient].chatManager sendMessage:message
                                            progress:nil
                                                 completion:^(AgoraChatMessage * _Nullable message, AgoraChatError * _Nullable error) {
        if (!error) {
            [weakself addMsgRecord:sendContent];
            if ([type isEqualToString:@"视频"]) {
                PGVideoCallViewController * vc = [[PGVideoCallViewController alloc] init];
                vc.channelId = senderId;
                vc.callType = 1;
                vc.dataDic = weakself.dataDic;
                vc.isVideoCard = YES;
                vc.priceModel = weakself.priceModel;
                PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = 0;
                [[PGUtils getCurrentVC] presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}
- (void)addMsgRecord:(NSString *)content
{
    NSString * senderId = [NSString stringWithFormat:@"%@",self.dataDic[@"senderid"]];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:senderId forKey:@"friendid"];
    [dic setValue:content forKey:@"content"];
    [dic setValue:@"" forKey:@"virtualAnchorid"];
    [PGAPIService messageSendAddRecordWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)loadCallPrice
{
    WeakSelf(self)
    [PGAPIService getCallPriceWithParameters:@{@"userid":self.dataDic[@"senderid"]} Success:^(id  _Nonnull data) {
        PGAnchorPriceModel * priceModel = [PGAnchorPriceModel mj_objectWithKeyValues:data[@"data"]];
        [weakself updateCallPriceWith:priceModel];
        weakself.priceModel = priceModel;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
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
#pragma mark===请求视频价格
- (void)loadAnchorCallCoin
{
    NSString * anchorId = self.dataDic[@"senderid"];
    if (anchorId.length==0) {
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:anchorId forKey:@"anchorid"];
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
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
#pragma mark===开启，结束忙碌
- (void)startBusy
{
    NSString * anchorId = self.dataDic[@"senderid"];
    if (anchorId.length==0) {
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:anchorId forKey:@"anchorUserId"];
    [dic setValue:@"video_voice" forKey:@"submitReason"];
    [PGAPIService startBusyStatusWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)endBusy
{
    NSString * anchorId = self.dataDic[@"senderid"];
    if (anchorId.length==0) {
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:anchorId forKey:@"anchorUserId"];
    [dic setValue:@"video_voice" forKey:@"submitReason"];
    [PGAPIService endBusyStatusWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.borderWidth = 1;
        _backView.layer.borderColor = HEX(#FFFFFF).CGColor;
        _backView.layer.cornerRadius = 20;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UIImageView *)coverImg
{
    if (!_coverImg) {
        _coverImg = [[UIImageView alloc] init];
        _coverImg.contentMode = UIViewContentModeScaleAspectFill;
        _coverImg.clipsToBounds = YES;
    }
    return _coverImg;
}
- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = HEXAlpha(#302F2F, 0.76f);
    }
    return _coverView;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:MPImage(@"close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.clipsToBounds = YES;
        _headImg.layer.cornerRadius = 37;
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
        _nameLabel.textColor = HEX(#FFFFFF);
        _nameLabel.text = @"昵称";
    }
    return _nameLabel;
}
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = MPFont(14);
        _tipsLabel.textColor = HEX(#FFFFFF);
        _tipsLabel.text = @"对方邀请你通话......";
    }
    return _tipsLabel;
}
- (UIButton *)acceptBtn
{
    if (!_acceptBtn) {
        _acceptBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 164, 80)];
        [_acceptBtn setImage:MPImage(@"acBg") forState:UIControlStateNormal];
        [_acceptBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [_acceptBtn startRipple:40 fromValue:@0.7 toValue:@1.0];
    }
    return _acceptBtn;
}
- (UIView *)priceView
{
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
//        _priceView.backgroundColor = HEXAlpha(#F5F5F5, 0.53f);
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
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
