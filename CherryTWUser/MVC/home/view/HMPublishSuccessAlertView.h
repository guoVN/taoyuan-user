//
//  HMPublishSuccessAlertView.h
//  CherryTWanchor
//
//  Created by guo on 2025/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMPublishSuccessAlertView : UIView

@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * sureBtn;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@property (nonatomic, copy) void(^sureBlock)(void);

@end

NS_ASSUME_NONNULL_END
