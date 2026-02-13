//
//  HMYuYueRecordModel.h
//  CherryTWanchor
//
//  Created by guo on 2025/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HMYuYueRecordListModel;
@interface HMYuYueRecordModel : NSObject

@property (nonatomic, strong) NSArray * orders;
@property (nonatomic, strong) NSArray<HMYuYueRecordListModel *> * records;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger searchCount;

@end

@class HMYuYuefemaleAdditionalModel;
@interface HMYuYueRecordListModel : NSObject

//数据主键
@property (nonatomic, assign) NSInteger ID;
///用户id
@property (nonatomic, assign) NSInteger userId;
///主播id
@property (nonatomic, assign) NSInteger anchorId;
///预约日期（如：2025-10-12）
@property (nonatomic, copy) NSString * scheduleDate;
///预约的小时单元（0-23，对应0点-23点）
@property (nonatomic, assign) NSInteger hourUnit;
///预约时长（10,20,30）
@property (nonatomic, assign) NSInteger reservationDuration;
///预约时间 10:00-11:00
@property (nonatomic, copy) NSString * timePeriod;
///昵称
@property (nonatomic, copy) NSString * nickName;
///头像
@property (nonatomic, copy) NSString * photo;
///预约状态1.待确认，2.已预约（女用户确认）3.已拒绝（女用户拒绝并退款），4.已完成，5. 有个超时未确认退款 
@property (nonatomic, assign) NSInteger reservationStatus;

@property (nonatomic, strong) NSArray<HMYuYuefemaleAdditionalModel *> * femaleAdditionalConfigList;
///消耗金币
@property (nonatomic, assign) NSInteger consumeCoin;

@property (nonatomic, copy) NSString * rejectReason;

@property (nonatomic, copy) NSString * anchorNickName;
@property (nonatomic, copy) NSString * createdTime;
@property (nonatomic, copy) NSString * updatedTime;
@property (nonatomic, copy) NSString * timePeriodByHourUnit;
@property (nonatomic, copy) NSString * reservationNo;
@property (nonatomic, copy) NSString * anchorPhoto;

@end

///附加项配置详情
@interface HMYuYuefemaleAdditionalModel : NSObject

@property (nonatomic, assign) NSInteger giftId;
///礼物价格 金币
@property (nonatomic, assign) NSInteger giftCoin;

@property (nonatomic, copy) NSString * updatedTime;
///配置id
@property (nonatomic, assign) NSInteger ID;
///附加项配置id
@property (nonatomic, assign) NSInteger configId;
///礼物图片
@property (nonatomic, copy) NSString * pic;

@property (nonatomic, copy) NSString * createdTime;
///主播id
@property (nonatomic, assign) NSInteger anchorId;
///附加项名称
@property (nonatomic, copy) NSString * configName;
///礼物名称
@property (nonatomic, copy) NSString * name;

@end

NS_ASSUME_NONNULL_END
