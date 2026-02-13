//
//  PGWithdrawalUserModel.h
//  CherryTWUser
//
//  Created by guo on 2025/2/6.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGWithdrawalUserModel : NSObject

@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, copy) NSString * withdrawMoney;
@property (nonatomic, assign) NSInteger minWithdrawMoney;
@property (nonatomic, assign) NSInteger withdrawIntegral;

@end

NS_ASSUME_NONNULL_END
