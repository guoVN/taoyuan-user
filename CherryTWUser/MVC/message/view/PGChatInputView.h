//
//  PGChatInputView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/16.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PGChatInputView;
@protocol PGChatInputViewDelegate <NSObject>

- (void)inputBar:(PGChatInputView *)textView didSendVoice:(NSString *)path;

@end

@interface PGChatInputView : UIView

@property (nonatomic, strong) UIButton * changeBtn;
@property (nonatomic, strong) QMUITextField * inputField;
@property (nonatomic, strong) UIButton * recordBtn;
@property (nonatomic, strong) UIButton * sendBtn;
@property (nonatomic, strong) UIStackView * menuStackView;
@property (nonatomic, strong) UIButton * giftBtn;
@property (nonatomic, strong) UIButton * albumBtn;
@property (nonatomic, strong) UIButton * videoCallBtn;
@property (nonatomic, strong) UIButton * emojiBtn;
@property (nonatomic, strong) UIView * lockView;
@property (nonatomic, strong) UIButton * lockBtn;
@property(nonatomic, weak) id<PGChatInputViewDelegate> delegate;

@property (nonatomic, copy) NSString * channelId;

@property (nonatomic, copy) void(^sendBlock)(NSString * sendContent);
@property (nonatomic, copy) void(^sendImgBlock)(NSString * imgUrl);
@property (nonatomic, copy) void(^sendVideoCallBlock)(void);
@property (nonatomic, copy) void(^chooseGiftBlock)(void);

@end

NS_ASSUME_NONNULL_END
