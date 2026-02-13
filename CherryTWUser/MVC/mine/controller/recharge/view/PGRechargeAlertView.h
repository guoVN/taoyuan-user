//
//  PGRechargeAlertView.h
//  CherryTWUser
//
//  Created by guo on 2025/11/3.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGRechargeAlertView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * totalDiamondLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UIButton * sureBtn;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
