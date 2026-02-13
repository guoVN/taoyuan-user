//
//  PGDynamicDetailPraiseListTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDynamicNoticeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGDynamicDetailPraiseListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) PGDynamicNoticeModel * model;

@end

NS_ASSUME_NONNULL_END
