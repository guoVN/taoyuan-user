//
//  PGAnchorModel.h
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PGAnchorDynamicModel,PGYuYuefemaleAdditionalModel,PGAnchorVideoModel;
@interface PGAnchorModel : NSObject

@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * anchorType;
@property (nonatomic, copy) NSString * constellation;
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, copy) NSString * dynamicBean;
@property (nonatomic, strong) NSArray<PGAnchorDynamicModel *> * dynamicList;
///情感状态
@property (nonatomic, copy) NSString * emotionState;
@property (nonatomic, copy) NSString * height;
@property (nonatomic, copy) NSString * isAttention;
@property (nonatomic, copy) NSString * job;
///标签
@property (nonatomic, copy) NSString * labelSelfEvaluation;
@property (nonatomic, copy) NSString * labelTopic;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * onlineState;
///介绍
@property (nonatomic, copy) NSString * personalSign;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * photo;
///相册
@property (nonatomic, strong) NSArray * photoUrls;
///罩杯
@property (nonatomic, copy) NSString * cup;
@property (nonatomic, copy) NSString * school;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * textChatCoin;
@property (nonatomic, copy) NSString * tips;
@property (nonatomic, assign) NSInteger userid;
///打视频扣费金币
@property (nonatomic, copy) NSString * videoCoin;
@property (nonatomic, strong) NSArray<PGAnchorVideoModel *> * videoUrls;
///打语音扣费金币
@property (nonatomic, copy) NSString * voiceCoin;
@property (nonatomic, copy) NSString * weChat;
@property (nonatomic, copy) NSString * weChatLookGrad;
@property (nonatomic, copy) NSString * weight;

@property (nonatomic, strong) NSArray<PGYuYuefemaleAdditionalModel *> * femaleAdditionalConfigList;
///自定义项目
@property (nonatomic, copy) NSString * customSign;
///颜值评定 1.A级，2.S级，3.SS级，4.网红级
@property (nonatomic, copy) NSString * appearance;

@end

@interface PGAnchorDynamicModel : NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString * auditUser;
@property (nonatomic, copy) NSString * btId;
@property (nonatomic, copy) NSString * channels;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, copy) NSString * constellation;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) NSInteger dynamicid;
@property (nonatomic, copy) NSString * fileType;
@property (nonatomic, copy) NSString * handleTime;
@property (nonatomic, copy) NSString * hot;
@property (nonatomic, copy) NSString * isAttention;
@property (nonatomic, assign) NSInteger isCheck;
@property (nonatomic, copy) NSString * isLike;
@property (nonatomic, copy) NSString * isUsed;
@property (nonatomic, assign) NSInteger leaderAudit;
@property (nonatomic, copy) NSString * leaderRefuseContent;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger maxCommentNum;
@property (nonatomic, assign) NSInteger maxLikeNum;
@property (nonatomic, copy) NSString * nickName;
///在线状态
@property (nonatomic, copy) NSString * onlineState;
///个性签名
@property (nonatomic, copy) NSString * personalSign;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * photoUrl;
@property (nonatomic, copy) NSString * refuseContent;
@property (nonatomic, assign) NSInteger reviewStatus;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, copy) NSString * topicName;
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, copy) NSString * validTime;
@property (nonatomic, copy) NSString * videoFrame;
@property (nonatomic, copy) NSString * videoUrl;

@end

///附加项配置详情
@interface PGYuYuefemaleAdditionalModel : NSObject

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

@interface PGAnchorVideoModel : NSObject

@property (nonatomic, copy) NSString * videoUrl;
@property (nonatomic, copy) NSString * thumbnailUrl;

@end

NS_ASSUME_NONNULL_END
