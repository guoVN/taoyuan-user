//
//  PGCallVideoAlertView.h
//  CherryTWUser
//
//  Created by guo on 2025/11/19.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGCallVideoAlertView : UIView

@property (nonatomic, strong) UIImageView * headImg;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * cancelBtn;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@property (nonatomic, strong) PGAnchorModel * detailModel;
@property (nonatomic, copy) NSString * scheduleDate;
@property (nonatomic, assign) NSInteger hourUnit;

@end

NS_ASSUME_NONNULL_END
