//
//  PGChatViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGChatViewController : PGBaseViewController

@property (nonatomic, copy) NSString * channelId;
@property (nonatomic, copy) NSString * friendHead;
@property (nonatomic, copy) NSString * friendName;

@end

NS_ASSUME_NONNULL_END
