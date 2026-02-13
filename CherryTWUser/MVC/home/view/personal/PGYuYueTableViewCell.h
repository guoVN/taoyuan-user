//
//  PGYuYueTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/10/24.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGYuYueModel.h"
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGYuYueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *lastDayBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *nextDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentDayLabel;
@property (weak, nonatomic) IBOutlet UIView *yuyueView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuyueViewHC;

@property (nonatomic, strong) PGYuYueModel * yuYueModel;
@property (nonatomic, strong) PGAnchorModel * detailModel;
@property (nonatomic, copy) void(^changeDayBlock)(NSString * scheduleDate);

@end

NS_ASSUME_NONNULL_END
