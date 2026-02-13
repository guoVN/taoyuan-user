//
//  PGPersonalDetailTagTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCollectionViewFlowLayout.h"
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalDetailTagTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customLabelBC;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIView *projectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectViewHC;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) void(^refreshBlock)(void);

@property (nonatomic, strong) PGAnchorModel * detailModel;

@end

NS_ASSUME_NONNULL_END
