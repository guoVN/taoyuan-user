//
//  PGPersonalYuYueAlertTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/11/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMPlayTypeProjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalYuYueAlertTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic, strong) HMPlayTypeProjectListModel * listModel;

@end

NS_ASSUME_NONNULL_END
