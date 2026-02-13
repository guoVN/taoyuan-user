//
//  PGWriteInviteCodeSureView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/18.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGWriteInviteCodeSureView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView * tipsImg;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * cancelBtn;

@property (nonatomic, copy) void(^sureBlock)(void);

@end

NS_ASSUME_NONNULL_END
