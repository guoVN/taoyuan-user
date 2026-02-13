//
//  PGPersonalTaDynamicCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalTaDynamicCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) PGAnchorDynamicModel * dynamicModel;

@end

NS_ASSUME_NONNULL_END
