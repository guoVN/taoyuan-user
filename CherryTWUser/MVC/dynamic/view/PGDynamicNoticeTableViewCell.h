//
//  PGDynamicNoticeTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDynamicNoticeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGDynamicNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImg;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;

@property (nonatomic, strong) PGDynamicNoticeModel * model;

@end

NS_ASSUME_NONNULL_END
