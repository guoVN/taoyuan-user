//
//  HMSureHangUpAlertView.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMSureHangUpAlertView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * cancelBtn;

///0.视频通话挂断弹窗，1.删除支付宝账户弹窗
@property (nonatomic, assign) NSInteger type;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@property (nonatomic, copy) void(^sureHangUpBlock)(void);

@end

NS_ASSUME_NONNULL_END
