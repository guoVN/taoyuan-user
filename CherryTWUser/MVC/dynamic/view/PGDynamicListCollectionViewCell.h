//
//  PGDynamicListCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/10/23.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGDynamicListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;

@property (nonatomic, strong) PGAnchorDynamicModel * model;

@end

NS_ASSUME_NONNULL_END
