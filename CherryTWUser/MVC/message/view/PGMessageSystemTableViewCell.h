//
//  PGMessageSystemTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/16.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGMessageChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGMessageSystemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) PGMessageChatModel * model;

@end

NS_ASSUME_NONNULL_END
