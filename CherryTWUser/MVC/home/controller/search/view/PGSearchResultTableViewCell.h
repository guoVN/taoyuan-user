//
//  PGSearchResultTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGHomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGSearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet UIImageView *onlineImg;

@property (nonatomic, strong) PGHomeListModel * model;

@end

NS_ASSUME_NONNULL_END
