//
//  PGInviteTableHeaderView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGInviteInComeModel.h"
#import "PGInviteInFriendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PGInviteTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@property (nonatomic, strong) PGInviteInComeModel * incomeModel;
@property (nonatomic, strong) PGInviteInFriendModel * friendModel;

@end

NS_ASSUME_NONNULL_END
