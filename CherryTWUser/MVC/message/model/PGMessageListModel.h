//
//  PGMessageListModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/14.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Realm/Realm.h>
#import "PGMessageChatModel.h"

NS_ASSUME_NONNULL_BEGIN

RLM_COLLECTION_TYPE(PGMessageChatModel)
@interface PGMessageListModel : RLMObject

///未读消息数量
@property  NSString * unReadNumStr;

@property RLMArray <PGMessageChatModel> * listArray;
///用户id作为消息ID，1为系统消息
@property  NSString * messageId;
///置顶状态
@property  NSString * topStatus;
///朋友头像
@property  NSString * avatar;
///朋友昵称
@property  NSString * nickName;
///备注
@property  NSString * remarks;
///发送者id
@property  NSString * extendStr1;

@property  NSString * extendStr2;
@property  NSString * extendStr3;
@property  NSString * extendStr4;
@property  NSString * extendStr5;
@property  NSString * extendStr6;
@property  NSString * extendStr7;
@property  NSString * extendStr8;
@property  NSString * extendStr9;
@property  NSString * extendStr10;

@end

NS_ASSUME_NONNULL_END
