//
//  PGInviteFriendListTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGInviteInComeModel.h"
#import "PGInviteInFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGInviteFriendListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *diamondsNumlabel;
@property (weak, nonatomic) IBOutlet UILabel *getConLabel;
@property (weak, nonatomic) IBOutlet UIImageView *diaImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) PGInviteInComeModelListRecordsModel * incomeListRecordModel;
@property (nonatomic, strong) PGInviteInFriendModelListRecordsModel * friendListRecordModel;

@end

NS_ASSUME_NONNULL_END
