//
//  PGFollowAndFansListTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/10/24.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMFansAndFollowListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGFollowAndFansListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) NSInteger vcIndex;
@property (nonatomic, strong) HMFansAndFollowListModel * listModel;
@property (nonatomic, copy) void(^cancelFollowBlock)(void);

@end

NS_ASSUME_NONNULL_END
