//
//  PGCustomAlertView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/5.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGCustomAlertView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView * tipsImg;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIView * hengView;
@property (nonatomic, strong) UIView * shuView;

///1.举报，2.删除动态，3.退出登录，4.注销账号，5.充值，6.转入到账户余额，7.拉黑
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * dynamicId;
@property (nonatomic, copy) void(^sureBlock)(void);

@end

NS_ASSUME_NONNULL_END
