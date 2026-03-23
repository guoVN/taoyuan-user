//
//  PGInviteBindTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2026/3/23.
//  Copyright © 2026 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGInviteBindTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;

@property (nonatomic, strong) PGAnchorModel * model;
@property (nonatomic, copy) void(^refreshStatusBlock)(void);

@end

NS_ASSUME_NONNULL_END
