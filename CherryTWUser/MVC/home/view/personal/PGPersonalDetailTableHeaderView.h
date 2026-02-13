//
//  PGPersonalDetailTableHeaderView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalDetailTableHeaderView : UIView

@property (nonatomic, strong) UIImageView * headImg;
@property (nonatomic, strong) UIImageView * onlineImg;
@property (nonatomic, strong) UIStackView * contentStackView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) QMUIButton * followBtn;
@property (nonatomic, strong) UIStackView * lineStackView;
@property (nonatomic, strong) UIView * grayView;
@property (nonatomic, strong) UILabel * onlineLabel;

@property (nonatomic, strong) PGAnchorModel * detailModel;
@property (nonatomic, assign) NSInteger isFollow;

@end

NS_ASSUME_NONNULL_END
