//
//  PGLoginModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/11.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGLoginModel : NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * addressBuriedPoint;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString * agent;
@property (nonatomic, copy) NSString * alipayAccount;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, copy) NSString * androidid;
@property (nonatomic, copy) NSString * antiHarassState;
@property (nonatomic, copy) NSString * apiVersion;
@property (nonatomic, copy) NSString * appName;
@property (nonatomic, copy) NSString * appmain;
@property (nonatomic, assign) NSInteger authState;
@property (nonatomic, copy) NSString * authStatus;
@property (nonatomic, assign) NSInteger aversion;
@property (nonatomic, copy) NSString * bankCard;
@property (nonatomic, assign) NSInteger basicsState;
@property (nonatomic, assign) NSInteger beliked;
@property (nonatomic, copy) NSString * callBackRateFlag;
@property (nonatomic, copy) NSString * callback;
@property (nonatomic, copy) NSString * channel;
@property (nonatomic, copy) NSString * channelNo;
@property (nonatomic, assign) NSInteger coin;
@property (nonatomic, assign) NSInteger concerns;
@property (nonatomic, assign) NSInteger consumeCoin;
@property (nonatomic, assign) NSInteger consumeIntegral;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) NSInteger dynamicState;
@property (nonatomic, copy) NSString * emotionState;
@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, assign) NSInteger firstLogin;
@property (nonatomic, assign) NSInteger headPortraitState;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy) NSString * idfa;
@property (nonatomic, copy) NSString * imei;
@property (nonatomic, assign) NSInteger initPushTimes;
@property (nonatomic, assign) NSInteger integral;
@property (nonatomic, copy) NSString * intervalEndTime;
@property (nonatomic, copy) NSString * intervalPushCount;
@property (nonatomic, copy) NSString * intervalStartTime;
@property (nonatomic, copy) NSString * invitationCode;
@property (nonatomic, copy) NSString * ip;
@property (nonatomic, copy) NSString * isAttention;
@property (nonatomic, copy) NSString * isBusy;
@property (nonatomic, copy) NSString * isCoordinateShield;
@property (nonatomic, assign) NSInteger isOld;
@property (nonatomic, assign) NSInteger isRecharge;
@property (nonatomic, assign) NSInteger isTextChat;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * lastTime;
@property (nonatomic, copy) NSString * lat;
@property (nonatomic, assign) NSInteger likeState;
@property (nonatomic, copy) NSString * lng;
@property (nonatomic, assign) NSInteger loginFlag;
@property (nonatomic, copy) NSString * loginTime;
@property (nonatomic, copy) NSString * loginToken;
@property (nonatomic, copy) NSString * mac;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * oaid;
@property (nonatomic, copy) NSString * openid;
@property (nonatomic, copy) NSString * os;
@property (nonatomic, copy) NSString * packName;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * personSign;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, assign) NSInteger photoState;
@property (nonatomic, assign) NSInteger presentCoin;
@property (nonatomic, copy) NSString * promotionChannel;
@property (nonatomic, copy) NSString * pushDeviceId;
@property (nonatomic, copy) NSString * pushInterval;
@property (nonatomic, copy) NSString * pushTotal;
@property (nonatomic, copy) NSString * realImei;
@property (nonatomic, assign) NSInteger sex;
///在线
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * superiorId;
@property (nonatomic, copy) NSString * sysPushSwitch;
@property (nonatomic, copy) NSString * textPushTime;
@property (nonatomic, copy) NSString * ua;
@property (nonatomic, copy) NSString * unionid;
@property (nonatomic, copy) NSString * userid;
@property (nonatomic, copy) NSString * uuid;
@property (nonatomic, assign) NSInteger vip;
@property (nonatomic, copy) NSString * vipExpireTime;
@property (nonatomic, assign) NSInteger weight;

+ (void)saveInfo:(NSDictionary*)dic;
+ (PGLoginModel*)readInfo;

@end

NS_ASSUME_NONNULL_END
