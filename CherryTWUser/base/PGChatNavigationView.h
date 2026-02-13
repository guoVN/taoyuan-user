//
//  PGChatNavigationView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGChatNavigationView : UIView

@property (nonatomic, strong) QMUIButton * backBtn;
@property (nonatomic, strong) UIImageView * headImg;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * sexImg;
@property (nonatomic, strong) QMUIButton * rightBtn;
@property (nonatomic, strong) UIView * priceView;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UIImageView * navImg;
@property (nonatomic, assign) BOOL showNavImg;

- (void)updateCallPriceWith:(PGAnchorPriceModel *)model;

@end

NS_ASSUME_NONNULL_END
