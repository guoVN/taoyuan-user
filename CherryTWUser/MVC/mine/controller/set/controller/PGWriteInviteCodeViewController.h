//
//  PGWriteInviteCodeViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/18.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGWriteInviteCodeViewController : PGBaseViewController

@property (nonatomic, copy) void(^bindInviteCodeBlock)(NSString * code);

@end

NS_ASSUME_NONNULL_END
