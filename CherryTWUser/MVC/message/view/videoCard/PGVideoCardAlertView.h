//
//  PGVideoCardAlertView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/30.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGVideoCardAlertView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIImageView * coverImg;
@property (nonatomic, strong) UIView * coverView;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UIImageView * headImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * tipsLabel;
@property (nonatomic, strong) UIButton * acceptBtn;
@property (nonatomic, strong) QMUIButton * showBtn;
@property (nonatomic, strong) UIView * priceView;
@property (nonatomic, strong) UILabel * priceLabel;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
