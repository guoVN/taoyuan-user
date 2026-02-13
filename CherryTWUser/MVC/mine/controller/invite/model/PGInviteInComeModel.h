//
//  PGInviteInComeModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/26.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PGInviteInComeModelListModel;
@interface PGInviteInComeModel : NSObject

@property (nonatomic, assign) NSInteger inviterSum;
@property (nonatomic, assign) NSInteger yesterdayInviterSum;
@property (nonatomic, assign) NSInteger todayInviterSum;
@property (nonatomic, strong) PGInviteInComeModelListModel * list;

@end

@class PGInviteInComeModelListRecordsModel;
@interface PGInviteInComeModelListModel : NSObject

@property (nonatomic, strong) NSArray <PGInviteInComeModelListRecordsModel *> * records;
@property (nonatomic, assign) NSInteger total;

@end

@interface PGInviteInComeModelListRecordsModel : NSObject

@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, assign) NSInteger integral;

@end

NS_ASSUME_NONNULL_END
