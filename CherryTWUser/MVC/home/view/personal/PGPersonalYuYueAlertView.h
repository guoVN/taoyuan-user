//
//  PGPersonalYuYueAlertView.h
//  CherryTWUser
//
//  Created by guo on 2025/11/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalYuYueAlertView : UIView

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIImageView * headImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * addProjectBtn;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * totalDiamondLabel;
@property (nonatomic, strong) QMUILabel * tipsLabel;
@property (nonatomic, strong) UIButton * sureBtn;
@property (nonatomic, strong) UIButton * cancelBtn;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@property (nonatomic, strong) PGAnchorModel * detailModel;
@property (nonatomic, copy) NSString * scheduleDate;
@property (nonatomic, assign) NSInteger hourUnit;
@property (nonatomic, copy) NSString * tipsStr;

@end

NS_ASSUME_NONNULL_END
