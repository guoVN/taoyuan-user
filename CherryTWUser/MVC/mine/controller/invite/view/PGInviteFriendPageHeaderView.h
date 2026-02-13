//
//  PGInviteFriendPageHeaderView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGInviteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGInviteFriendPageHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *persentLabel;

@property (nonatomic, strong) PGInviteModel * inviteModel;

@end

NS_ASSUME_NONNULL_END
