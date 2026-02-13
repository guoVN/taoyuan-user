//
//  PGCallRechargeView.h
//  CherryTWUser
//
//  Created by guo on 2025/1/5.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGCallRechargeView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIButton * closeBtn;

@property (nonatomic, copy) void(^refreshCoinBlock)(void);

@end

NS_ASSUME_NONNULL_END
