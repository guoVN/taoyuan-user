//
//  HMPlayTypeAddProjectView.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import <UIKit/UIKit.h>
#import "HMPlayTypeProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMPlayTypeAddProjectView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UIButton * sureBtn;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView;

@property (nonatomic, strong) HMPlayTypeProjectModel * projectModel;
@property (nonatomic, copy) void(^chooseProjectBlock)(NSMutableArray * chooseArr);

@end

NS_ASSUME_NONNULL_END
