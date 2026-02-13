//
//  PGDeleteAccountAlertView.h
//  CherryTWUser
//
//  Created by guo on 2025/1/20.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGDeleteAccountAlertView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * sureBtn;

@property (nonatomic, copy) NSString * cardNo;

@end

NS_ASSUME_NONNULL_END
