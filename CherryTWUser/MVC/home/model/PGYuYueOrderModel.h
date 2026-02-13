//
//  PGYuYueOrderModel.h
//  CherryTWUser
//
//  Created by guo on 2025/11/19.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGYuYueOrderModel : NSObject

@property (nonatomic, assign) NSInteger ID;
///预约日期
@property (nonatomic, copy) NSString * scheduleDate;
@property (nonatomic, copy) NSString * rejectReason;
@property (nonatomic, copy) NSString * anchorNickName;
///预约状态
@property (nonatomic, assign) NSInteger reservationStatus;
@property (nonatomic, copy) NSString * createdTime;
@property (nonatomic, copy) NSString * updatedTime;
///预约时段
@property (nonatomic, copy) NSString * timePeriodByHourUnit;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString * reservationNo;
@property (nonatomic, strong) NSArray * femaleAdditionalConfigList;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, assign) NSInteger hourUnit;
@property (nonatomic, assign) NSInteger anchorId;
@property (nonatomic, assign) NSInteger reservationDuration;
@property (nonatomic, copy) NSString * timePeriod;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * anchorPhoto;

@end

NS_ASSUME_NONNULL_END
