//
//  PGPersonalDetailViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalDetailViewController : PGBaseViewController

@property (nonatomic, copy) NSString * anchorid;
@property (nonatomic, assign) BOOL isFromChat;

@end

NS_ASSUME_NONNULL_END
