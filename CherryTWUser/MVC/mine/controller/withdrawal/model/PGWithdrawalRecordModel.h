//
//  PGWithdrawalRecordModel.h
//  CherryTWUser
//
//  Created by guo on 2025/2/15.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGWithdrawalRecordModel : NSObject

@property (nonatomic, copy) NSString * account;
@property (nonatomic, assign) NSInteger bindId;
@property (nonatomic, assign) NSInteger configId;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * realName;
@property (nonatomic, assign) NSInteger source;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger unionId;
@property (nonatomic, copy) NSString * unionName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger withdrawConfigId;
@property (nonatomic, assign) NSInteger withdrawalId;
@property (nonatomic, assign) NSInteger withdrawalIntegral;
@property (nonatomic, copy) NSString * withdrawalMoneyAmount;
@property (nonatomic, assign) NSInteger withdrawalStatus;
@property (nonatomic, assign) NSInteger withdrawalType;
@property (nonatomic, copy) NSString * cardNo;
@property (nonatomic, copy) NSString * channel;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, assign) NSInteger residualIntegral;
@property (nonatomic, assign) NSInteger residualMoney;

@end

@interface PGWithdrawalRecordListModel : NSObject


@end
