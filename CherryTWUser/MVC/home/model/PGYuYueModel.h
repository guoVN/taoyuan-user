//
//  PGYuYueModel.h
//  CherryTWUser
//
//  Created by guo on 2025/11/17.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PGYuYueDataModelTimeModel;
@interface PGYuYueModel : NSObject

///是否有新待确认预约单
@property (nonatomic, assign) BOOL haveNewOrder;
///查询日期
@property (nonatomic, copy) NSString * scheduleDate;
@property (nonatomic, strong) NSMutableArray<PGYuYueDataModelTimeModel *> * morning;
@property (nonatomic, strong) NSMutableArray<PGYuYueDataModelTimeModel *>  * afternoon;
@property (nonatomic, strong) NSMutableArray<PGYuYueDataModelTimeModel *>  * night;
@property (nonatomic, copy) NSString * weekDay;
@property (nonatomic, assign) NSInteger anchorId;
@property (nonatomic, copy) NSString * tips;

@end

@interface PGYuYueDataModelTimeModel : NSObject

///该时间对应的状态   0, "休息",1, "空闲",2, "紧张(预约时间>=10min，<40min)",3,  "约满(时间大于40分钟)",4, "空白(已经过去的时间)"
@property (nonatomic, assign) NSInteger status;
///时间(整点小时 1代表01:00)
@property (nonatomic, assign) NSInteger hourUnit;
///日期
@property (nonatomic, copy) NSString * scheduleDate;

@end

NS_ASSUME_NONNULL_END
