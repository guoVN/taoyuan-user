//
//  HMBlackAlertView.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMBlackAlertView : UIView

@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * cancelBtn;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;
@property (nonatomic, copy) void(^sureBlock)(void);

@end

NS_ASSUME_NONNULL_END
