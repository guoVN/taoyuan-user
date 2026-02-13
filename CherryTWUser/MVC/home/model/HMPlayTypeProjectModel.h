//
//  HMPlayTypeProjectModel.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HMPlayTypeProjectListModel;
@interface HMPlayTypeProjectModel : NSObject

@property (nonatomic, strong) NSArray<HMPlayTypeProjectListModel *> * femaleAdditionalConfigList;
@property (nonatomic, strong) NSArray<HMPlayTypeProjectListModel *> *selectorConfigs;
@property (nonatomic, assign) NSInteger anchorId;

@end

@interface HMPlayTypeProjectListModel : NSObject

@property (nonatomic, copy) NSString * createdTime;
///礼物价格(金币)
@property (nonatomic, assign) NSInteger giftCoin;
///礼物id
@property (nonatomic, assign) NSInteger giftId;
///礼物名称
@property (nonatomic, copy) NSString * giftName;
///数据主键
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger maxGiftPrice;
@property (nonatomic, assign) NSInteger minGiftPrice;
///附加项名称
@property (nonatomic, copy) NSString * name;
///排序
@property (nonatomic, assign) NSInteger sortOrder;
@property (nonatomic, copy) NSString * updatedTime;
///礼物图片
@property (nonatomic, copy) NSString * pic;
///项目名称
@property (nonatomic, copy) NSString * configName;

@end

NS_ASSUME_NONNULL_END
