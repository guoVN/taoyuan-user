//
//  HMFansAndFollowListModel.h
//  CherryTWanchor
//
//  Created by guo on 2025/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMFansAndFollowListModel : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString * photoUrl;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger height;
///情感状态：单身、已婚、离异
@property (nonatomic, copy) NSString * emotionState;
///谁看过我的时间
@property (nonatomic, copy) NSString * lookTime;
@property (nonatomic, copy) NSString * isAttention;
///虚拟主播id
@property (nonatomic, assign) NSInteger virtualAnchorMappingId;
///女用户是否通过系统推送过给男用户
@property (nonatomic, assign) NSInteger isPushToUser;
///是否建立关联
@property (nonatomic, assign) NSInteger isAssociation;

@end

NS_ASSUME_NONNULL_END
