//
//  PGUnlockChatAlertView.h
//  CherryTWUser
//
//  Created by guo on 2025/10/26.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGUnlockChatAlertView : UIView

@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * cancelBtn;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

///1.解锁消息，2.未使用预约单，3.颜值颜值
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) void(^sureBlock)(void);
@property (nonatomic, copy) void(^cancelBlock)(void);

@end

NS_ASSUME_NONNULL_END
