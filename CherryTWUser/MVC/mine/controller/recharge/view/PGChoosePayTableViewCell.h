//
//  PGChoosePayTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/11/3.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGChoosePayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;

@end

NS_ASSUME_NONNULL_END
