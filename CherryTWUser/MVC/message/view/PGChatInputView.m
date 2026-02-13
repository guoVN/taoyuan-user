//
//  PGChatInputView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/16.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGChatInputView.h"
#import "TUIRecordView.h"
#import "TUIAudioRecorder.h"
#import "TUICommonModel.h"
#import "TZImagePickerHelper.h"
#import "CherryTWUser-swift.h"
#import <MCEmojiPicker-Swift.h>
#import "PGEmojiView.h"
#import "PGUnlockChatAlertView.h"

@interface PGChatInputView ()<TUIAudioRecorderDelegate,MCEmojiPickerDelegate,QMUITextFieldDelegate>

@property(nonatomic, strong) TUIRecordView *recordView;
@property(nonatomic, strong) NSDate *recordStartTime;
@property(nonatomic, strong) TUIAudioRecorder *recorder;
@property (nonatomic, strong) TZImagePickerHelper * helper;
@property (nonatomic, strong) PGEmojiView * emojiView;

@end

@implementation PGChatInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX(#FFFFFF);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
//    [self addSubview:self.changeBtn];
    [self addSubview:self.inputField];
//    [self addSubview:self.recordBtn];
    [self addSubview:self.sendBtn];
    [self addSubview:self.giftBtn];
    [self addSubview:self.videoCallBtn];
    [self addSubview:self.emojiBtn];
    [self addSubview:self.lockView];
    [self.lockView addSubview:self.lockBtn];
}
- (void)snapSubView
{
//    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.top.mas_equalTo(16);
//        make.width.height.mas_equalTo(25);
//    }];
    [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.equalTo(self.sendBtn.mas_left).offset(-10);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(34);
    }];
//    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.changeBtn.mas_right).offset(13);
//        make.right.equalTo(self.sendBtn.mas_left).offset(-13);
//        make.top.mas_equalTo(12);
//        make.height.mas_equalTo(32);
//    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(67, 34));
    }];
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(47);
        make.top.equalTo(self.inputField.mas_bottom).offset(20);
        make.width.height.mas_equalTo(30);
    }];
    [self.videoCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.inputField.mas_bottom).offset(20);
        make.width.height.mas_equalTo(30);
    }];
    [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-47);
        make.top.equalTo(self.inputField.mas_bottom).offset(20);
        make.width.height.mas_equalTo(30);
    }];
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(15);
    }];
}
- (void)setChannelId:(NSString *)channelId
{
    _channelId = channelId;
//    [self checkChatLock];
}
- (void)checkChatLock
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.channelId forKey:@"anchorId"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [PGAPIService checkChatLockWithParameters:dic Success:^(id  _Nonnull data) {
        BOOL unLock = [data[@"data"] boolValue];
        weakself.lockView.alpha = unLock == YES ? 0 : 1;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===语音文字切换
- (void)changeBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.inputField.alpha = 0;
        self.recordBtn.alpha = 1;
        [self.inputField endEditing:YES];
    }else{
        self.inputField.alpha = 1;
        self.recordBtn.alpha = 0;
        [self.inputField becomeFirstResponder];
    }
}

#pragma mark===发送
- (void)sendBtnAction
{
    NSString * inputStr = self.inputField.text;
    NSString * sendStr = [inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (sendStr.length == 0) {
        return;
    }
    if (self.sendBlock) {
        self.sendBlock(sendStr);
//        self.inputField.text = @"";
    }
}
- (void)emojiBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.inputField.inputView = self.emojiView;
    }else{
        self.inputField.inputView = nil;
    }
    [self.inputField reloadInputViews];
    [self.inputField becomeFirstResponder];
}
- (void)videoCallBtnAction
{
    if (self.sendVideoCallBlock) {
        self.sendVideoCallBlock();
    }
}
- (void)giftBtnAction
{
    if (self.chooseGiftBlock) {
        self.chooseGiftBlock();
    }
}
- (void)lockBtnAction
{
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
            PGUnlockChatAlertView *view = [[PGUnlockChatAlertView alloc] initWithFrame:CGRectMake(0, 0, 305, 160) superView:mainView];
                view.type = 1;
                view.sureBlock = ^{
                    [weakself updateLock];
                };
                return view;
            })
        .wStart();
}
- (void)updateLock
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.channelId forKey:@"anchorId"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [PGAPIService updateChatLockWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.lockView.alpha = 0;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)didGetEmojiWithEmoji:(NSString * _Nonnull)emoji {
    self.inputField.text = [self.inputField.text stringByAppendingString:emoji];
}

#pragma mark - TUIAudioRecorderDelegate
- (void)audioRecorder:(TUIAudioRecorder *)recorder didCheckPermission:(BOOL)isGranted isFirstTime:(BOOL)isFirstTime {
    if (isFirstTime) {
        if (!isGranted) {
            [self showRequestMicAuthorizationAlert];
        }
        return;
    }

    [self updateViewsToRecordingStatus];
}

- (void)showRequestMicAuthorizationAlert {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启" message:@"无法使用发送语音消息、拍摄视频、音视频通话等功能，点击\"去开启\"打开麦克风权限"
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [ac tuitheme_addAction:[UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:nil]];
    [ac tuitheme_addAction:[UIAlertAction actionWithTitle:@"去开启"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *_Nonnull action) {
                                                    UIApplication *app = [UIApplication sharedApplication];
                                                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                    if ([app canOpenURL:settingsURL]) {
                                                        [app openURL:settingsURL];
                                                    }
                                                  }]];
    dispatch_async(dispatch_get_main_queue(), ^{
      [[PGUtils getCurrentVC] presentViewController:ac animated:YES completion:nil];
    });
}

- (void)updateViewsToRecordingStatus {
    [self.window addSubview:self.recordView];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.window);
        make.width.height.mas_equalTo(self.window);
    }];
    self.recordStartTime = [NSDate date];
    [self.recordView setStatus:Record_Status_Recording];
    self.recordBtn.backgroundColor = [UIColor lightGrayColor];
    [self.recordBtn setTitle:@"松开 发送" forState:UIControlStateNormal];
    [self showHapticFeedback];
}

- (void)audioRecorder:(TUIAudioRecorder *)recorder didPowerChanged:(float)power {
    if (!self.recordView.hidden) {
        [self.recordView setPower:power];
    }
}

- (void)audioRecorder:(TUIAudioRecorder *)recorder didRecordTimeChanged:(NSTimeInterval)time {
    float maxDuration = 59;
    NSInteger seconds = maxDuration - time;
    self.recordView.timeLabel.text = [[NSString alloc] initWithFormat:@"%ld\"", (long)seconds + 1];
    if (time >= 55 && time <= maxDuration) {
        NSInteger seconds = maxDuration - time;
        /**
         * 此处强转了 long 型，是为了消除编译器警告。
         * 此处 +1 是为了向上取整，优化时间逻辑。
         *
         * The long type is cast here to eliminate compiler warnings.
         * Here +1 is to round up and optimize the time logic.
         */
        self.recordView.title.text = [NSString stringWithFormat:@"将在 %ld 秒后结束录制", (long)seconds + 1];
    } else if (time > maxDuration) {
        [self.recorder stop];
        NSString *path = self.recorder.recordedFilePath;
        [self.recordView setStatus:Record_Status_TooLong];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self.recordView removeFromSuperview];
          self.recordView = nil;
        });
        if (path) {
            if (_delegate && [_delegate respondsToSelector:@selector(inputBar:didSendVoice:)]) {
                [_delegate inputBar:self didSendVoice:path];
            }
        }
    }
}
- (void)onRecordButtonTouchDown:(UIButton *)sender {
    [self.recorder record];
}

- (void)onRecordButtonTouchUpInside:(UIButton *)sender {
    self.recordBtn.backgroundColor = HEX(#FFFFFF);
    [self.recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];

    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.recordStartTime];
    if (interval < 1) {
        [self.recordView setStatus:Record_Status_TooShort];
        [self.recorder cancel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self.recordView removeFromSuperview];
          self.recordView = nil;
        });
    } else if (interval > 60) {
        [self.recordView setStatus:Record_Status_TooLong];
        [self.recorder cancel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self.recordView removeFromSuperview];
          self.recordView = nil;
        });
    } else {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
          /// TUICallKit may need some time to stop all services, so remove UI immediately then stop the recorder.
          [self.recordView removeFromSuperview];
          self.recordView = nil;
          dispatch_async(main_queue, ^{
            [self.recorder stop];
            NSString *path = self.recorder.recordedFilePath;
            if (path) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(inputBar:didSendVoice:)]) {
                    [self.delegate inputBar:self didSendVoice:path];
                }
            }
          });
        });
    }
}

- (void)onRecordButtonTouchCancel:(UIButton *)sender {
    [self.recordView removeFromSuperview];
    self.recordView = nil;
    self.recordBtn.backgroundColor = HEX(#FFFFFF);
    [self.recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recorder cancel];
}

- (void)onRecordButtonTouchDragExit:(UIButton *)sender {
    [self.recordView setStatus:Record_Status_Cancel];
    [self.recordBtn setTitle:@"松开 取消" forState:UIControlStateNormal];
}

- (void)onRecordButtonTouchDragEnter:(UIButton *)sender {
    [self.recordView setStatus:Record_Status_Recording];
    [self.recordBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
}
- (void)showHapticFeedback {
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
          UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
          [generator prepare];
          [generator impactOccurred];
        });

    } else {
        // Fallback on earlier versions
    }
}

#pragma mark===QMUITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendBtnAction];
    return YES;
}
#pragma mark===上传图片
- (void)updateHeadImg:(UIImage *)image
{
//    WeakSelf(self)
    [QMUITips showLoading:@"图片发送中" inView:[PGUtils getCurrentVC].view];
    [PGAPIService uploadFileWithImages:@[image] Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
//        NSString * imgStr = data[@"data"];
//        if (weakself.sendImgBlock) {
//            weakself.sendImgBlock(imgStr);
//        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:@"发送失败"];
    }];
}

#pragma mark===懒加载
- (UIButton *)changeBtn
{
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc] init];
        [_changeBtn setImage:MPImage(@"record") forState:UIControlStateNormal];
        [_changeBtn setImage:MPImage(@"keyboard") forState:UIControlStateSelected];
        [_changeBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}
- (QMUITextField *)inputField
{
    if (!_inputField) {
        _inputField = [[QMUITextField alloc] init];
        _inputField.backgroundColor = HEX(#F1F2F4);
        _inputField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _inputField.placeholder = @"请输入你想发送的话";
        _inputField.placeholderColor = HEX(#BABABA);
        _inputField.textColor = HEX(#333333);
        _inputField.layer.cornerRadius = 17;
        _inputField.layer.masksToBounds = YES;
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 32)];
        _inputField.leftView = view;
        _inputField.leftViewMode = UITextFieldViewModeAlways;
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.returnKeyType = UIReturnKeySend;
        _inputField.delegate = self;
    }
    return _inputField;
}
- (UIButton *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] init];
        _recordBtn.backgroundColor = HEX(#FFFFFF);
        [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:HEX(#333333) forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightHeavy];
        _recordBtn.layer.cornerRadius = 16;
        _recordBtn.layer.masksToBounds = YES;
        [_recordBtn addTarget:self action:@selector(onRecordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(onRecordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(onRecordButtonTouchCancel:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_recordBtn addTarget:self action:@selector(onRecordButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_recordBtn addTarget:self action:@selector(onRecordButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        _recordBtn.alpha = 0;
    }
    return _recordBtn;
}
- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        _sendBtn.backgroundColor = HEX(#FF6B97);
        [_sendBtn setTitle:Localized(@"发送") forState:UIControlStateNormal];
        [_sendBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = MPFont(14);
        _sendBtn.layer.cornerRadius = 17;
        _sendBtn.layer.masksToBounds = YES;
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
- (UIButton *)giftBtn
{
    if (!_giftBtn) {
        _giftBtn = [[UIButton alloc] init];
        [_giftBtn setImage:MPImage(@"giftTab") forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(giftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftBtn;
}
- (UIButton *)videoCallBtn
{
    if (!_videoCallBtn) {
        _videoCallBtn = [[UIButton alloc] init];
        [_videoCallBtn setImage:MPImage(@"videocall") forState:UIControlStateNormal];
        [_videoCallBtn addTarget:self action:@selector(videoCallBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoCallBtn;
}
- (UIButton *)emojiBtn
{
    if (!_emojiBtn) {
        _emojiBtn = [[UIButton alloc] init];
        [_emojiBtn setImage:MPImage(@"emoji") forState:UIControlStateNormal];
        [_emojiBtn setImage:MPImage(@"keyboard") forState:UIControlStateSelected];
        _emojiBtn.selected = NO;
        [_emojiBtn addTarget:self action:@selector(emojiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn;
}

- (TUIAudioRecorder *)recorder {
    if (!_recorder) {
        _recorder = [[TUIAudioRecorder alloc] init];
        _recorder.delegate = self;
    }
    return _recorder;
}

- (TUIRecordView *)recordView {
    if (!_recordView) {
        _recordView = [[TUIRecordView alloc] init];
        _recordView.frame = self.frame;
    }
    return _recordView;
}

- (TZImagePickerHelper *)helper {
    if (!_helper) {
        _helper = [[TZImagePickerHelper alloc] init];
         WeakSelf(self)
        _helper.finish = ^(NSArray *array){
            for (int i = 0; i< array.count; i++) {
                UIImage *image = [UIImage imageWithContentsOfFile:array[i]];
                NSData *data=UIImageJPEGRepresentation(image,1.0f);
                if (data != nil) {
                    if ([data length]>2*1024*2014) {
                        data = [PGUtils resetSizeOfImageData:[UIImage imageWithData:data] maxSize:2048];
                    }
                    image = [UIImage imageWithData:data];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself updateHeadImg:image];
                });
            }
        };
    }
    return _helper;
}
- (PGEmojiView *)emojiView
{
    if (!_emojiView) {
        _emojiView = [[PGEmojiView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
        _emojiView.pickerVC.delegate = self;
    }
    return _emojiView;
}
- (UIView *)lockView
{
    if (!_lockView) {
        _lockView = [[UIView alloc] init];
        _lockView.backgroundColor = HEX(#FFFFFF);
        _lockView.alpha = 0;
    }
    return _lockView;
}
- (UIButton *)lockBtn
{
    if (!_lockBtn) {
        _lockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-30, 50)];
        _lockBtn.backgroundColor = HEX(#FF6B97);
//        [_lockBtn setTitle:Localized(@"3钻石，解锁Ta的聊天框") forState:UIControlStateNormal];
        [_lockBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _lockBtn.titleLabel.font = MPMediumFont(18);
        _lockBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:151/255.0 alpha:1].CGColor;
        _lockBtn.layer.cornerRadius = 25;
        _lockBtn.layer.shadowColor = [UIColor colorWithRed:31/255.0 green:3/255.0 blue:11/255.0 alpha:0.5000].CGColor;
        _lockBtn.layer.shadowOffset = CGSizeMake(0,0);
        _lockBtn.layer.shadowOpacity = 1;
        _lockBtn.layer.shadowRadius = 20;
        [_lockBtn addTarget:self action:@selector(lockBtnAction) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld  ，解锁Ta的聊天框",[[PGManager shareModel].chatUnlockCoin integerValue]/100]];
        NSTextAttachment * attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"diamonds"];
        attach.bounds = CGRectMake(0, -3, 20, 20);
        NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
        [att insertAttributedString:attrStringWithImage atIndex:2];
        [_lockBtn setAttributedTitle:att forState:UIControlStateNormal];
    }
    return _lockBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
