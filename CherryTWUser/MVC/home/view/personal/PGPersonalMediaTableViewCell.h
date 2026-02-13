//
//  PGPersonalMediaTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/10/23.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalMediaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *showOneImg;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (nonatomic, strong) PGAnchorModel * detailModel;

@end

NS_ASSUME_NONNULL_END
