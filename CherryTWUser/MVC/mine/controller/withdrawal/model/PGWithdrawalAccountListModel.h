//
//  PGWithdrawalAccountListModel.h
//  CherryTWUser
//
//  Created by guo on 2025/2/15.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGWithdrawalAccountListModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString * realName;
@property (nonatomic, copy) NSString * idCard;
///支付宝账号
@property (nonatomic, copy) NSString * cardNo;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger state;

@end

NS_ASSUME_NONNULL_END
