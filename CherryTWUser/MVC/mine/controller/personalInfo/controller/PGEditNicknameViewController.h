//
//  PGEditNicknameViewController.h
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGEditNicknameViewController : PGBaseViewController
///1.昵称，2.个性签名
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * contentStr;

@property (nonatomic, copy) void(^updateBlock)(NSString * result);

@end

NS_ASSUME_NONNULL_END
