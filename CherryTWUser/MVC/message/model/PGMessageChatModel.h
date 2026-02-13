//
//  PGMessageChatModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/14.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGMessageChatModel : RLMObject
///主播id
@property  NSString * anchorId;
///消息id，与当前用户id一样就显示右边cell
@property  NSString * messageId;
///头像
@property  NSString * headStr;
///昵称
@property  NSString * nickNameStr;
///内容
@property  NSString * contenStr;
///时间戳
@property  NSString * timeStampStr;
///消息类型
@property  NSString * messageType;

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
