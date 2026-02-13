//
//  PGEditInfoTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGEditInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelRC;

@end

NS_ASSUME_NONNULL_END
