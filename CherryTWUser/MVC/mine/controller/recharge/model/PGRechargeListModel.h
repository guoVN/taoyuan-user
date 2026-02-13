//
//  PGRechargeListModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/26.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PGRechargeListCoinModel,PGotherSettingModel;
@interface PGRechargeListModel : NSObject

@property (nonatomic, strong) NSArray<PGRechargeListCoinModel *> * coins;
@property (nonatomic, strong) NSArray * vips;
@property (nonatomic, strong) PGotherSettingModel * otherSetting;

@end

@interface PGRechargeListCoinModel : NSObject

@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger coin;

@end

@class PGGiftListModel;
@interface PGotherSettingModel : NSObject

@property (nonatomic, strong) NSArray<PGGiftListModel *> * presentCoins;

@end

@interface PGGiftListModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString * pic;
@property (nonatomic, copy) NSString * dynamicPic;
@property (nonatomic, assign) NSInteger coin;
@property (nonatomic, assign) NSInteger sorts;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger giftBatchId;

@end



NS_ASSUME_NONNULL_END
