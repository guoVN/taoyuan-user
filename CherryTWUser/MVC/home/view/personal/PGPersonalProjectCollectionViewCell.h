//
//  PGPersonalProjectCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/10/23.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalProjectCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftIcon;

@property (nonatomic, strong) PGYuYuefemaleAdditionalModel * menuModel;

@end

NS_ASSUME_NONNULL_END
