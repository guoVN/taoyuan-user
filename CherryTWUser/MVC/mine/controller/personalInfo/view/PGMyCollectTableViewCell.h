//
//  PGMyCollectTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/17.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGMyCollectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGMyCollectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (nonatomic, strong) PGMyCollectModel * model;

@end

NS_ASSUME_NONNULL_END
