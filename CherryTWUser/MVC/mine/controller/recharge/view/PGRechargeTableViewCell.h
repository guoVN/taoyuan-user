//
//  PGRechargeTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGRechargeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;

@end

NS_ASSUME_NONNULL_END
