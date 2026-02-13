//
//  PGBaseNavigationView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/2.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGBaseNavigationView : UIView

@property (nonatomic, strong) QMUIButton * backBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) QMUIButton * titleBtn;
@property (nonatomic, strong) QMUIButton * rightBtn;
@property (nonatomic, strong) UIImageView * navImg;
@property (nonatomic, assign) BOOL showNavImg;

@end

NS_ASSUME_NONNULL_END
