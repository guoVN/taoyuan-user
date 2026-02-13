//
//  PGPersonalYuYueAlertCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/11/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalYuYueAlertCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet QMUIButton *diamondBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PGAnchorModel * detailModel;

@end

NS_ASSUME_NONNULL_END
