//
//  PGEditHeadTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGEditHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (nonatomic, copy) void(^updateHeadBlock)(void);

@end

NS_ASSUME_NONNULL_END
