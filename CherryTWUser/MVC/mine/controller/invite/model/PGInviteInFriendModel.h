//
//  PGInviteInFriendModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/26.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PGInviteInFriendModelListModel;
@interface PGInviteInFriendModel : NSObject

@property (nonatomic, assign) NSInteger inviterCount;
@property (nonatomic, assign) NSInteger yesterdayCount;
@property (nonatomic, assign) NSInteger todayCount;
@property (nonatomic, strong) PGInviteInFriendModelListModel * list;

@end

@class PGInviteInFriendModelListRecordsModel;
@interface PGInviteInFriendModelListModel : NSObject

@property (nonatomic, strong) NSArray <PGInviteInFriendModelListRecordsModel *> * records;
@property (nonatomic, assign) NSInteger total;

@end

@interface PGInviteInFriendModelListRecordsModel : NSObject

@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, copy) NSString * photo;

@end

NS_ASSUME_NONNULL_END
