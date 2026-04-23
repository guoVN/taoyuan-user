//
//  PGBindPhoneViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGBindPhoneViewController : PGBaseViewController

@property (nonatomic, copy) void(^refreshBlock)(void);

@end

NS_ASSUME_NONNULL_END
