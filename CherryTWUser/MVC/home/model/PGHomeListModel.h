//
//  PGHomeListModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGHomeListModel : NSObject

@property (nonatomic, assign) NSInteger isBusy;
@property (nonatomic, assign) NSInteger userid;
///标签
@property (nonatomic, copy) NSString * labels;
@property (nonatomic, assign) NSInteger dataType;
@property (nonatomic, copy) NSString * textChatCoin;
@property (nonatomic, copy) NSString * videoCoin;
@property (nonatomic, copy) NSString * voiceCoin;
///相册
@property (nonatomic, strong) NSArray * albums;
///情感状态
@property (nonatomic, copy) NSString * emotionState;
///星座
@property (nonatomic, copy) NSString * constellation;
///昵称
@property (nonatomic, copy) NSString * name;
///在线状态
@property (nonatomic, copy) NSString * onlineState;
@property (nonatomic, copy) NSString * callsuccess;
//可约状态
@property (nonatomic, copy) NSString * state;
///个性签名
@property (nonatomic, copy) NSString * sign;
///主播类型
@property (nonatomic, copy) NSString * anchorType;
@property (nonatomic, copy) NSString * appointments;
///身高
@property (nonatomic, copy) NSString * height;
///距离
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * channels;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * photoUrl;
@property (nonatomic, assign) NSInteger powerWeight;
@property (nonatomic, assign) NSInteger chatWeight;
@property (nonatomic, copy) NSString * intState;
@property (nonatomic, assign) NSInteger giftWeight;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * personality;
@property (nonatomic, copy) NSString * school;
@property (nonatomic, copy) NSString * hobby;
@property (nonatomic, copy) NSString * job;

@end

NS_ASSUME_NONNULL_END
