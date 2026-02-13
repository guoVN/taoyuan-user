//
//  PGManager.h
//  CherryTWUser
//
//  Created by guo on 2024/4/9.
//

#import <Foundation/Foundation.h>
#import "PGLoginModel.h"
#import "PGRechargeListModel.h"

typedef void(^chooseImgSuccessBlock)(NSArray * imgArr);
typedef void(^finishChooseVideoBlock)(UIImage * coverImg,NSURL * videoUrl);

@interface PGManager : NSObject

/**
 *  返回单例
 *
 *  @return 单例
 */
+(PGManager*)shareModel;
///访问域名
@property (nonatomic, copy) NSString * baseUrl;
///客服链接
@property (nonatomic, copy) NSString * searviceLinkStr;
///ua
@property (nonatomic, copy) NSString * userAgent;
///channelNo
@property (nonatomic, copy) NSString * channelNo;
///promptionChannel
@property (nonatomic, copy) NSString * promptionChannel;
///聊天解锁金币
@property (nonatomic, copy) NSString * chatUnlockCoin;

@property (nonatomic, strong) PGLoginModel * userInfo;

///当前选中礼物的tag
@property (nonatomic, assign) NSInteger currentChooseGiftTag;
///当前选中的礼物
@property (nonatomic, assign) PGGiftListModel * currentChooseGiftModel;
///礼物数组
@property (nonatomic, strong) NSMutableArray * giftArray;
///音频播放器
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;
///视频通话初始扣费时间节点
@property (nonatomic, assign) NSInteger videoFirstRecharTime;
///当前拨打视频扣费价格
@property (nonatomic, assign) NSInteger callCoin;
///当前通话主播id
@property (nonatomic, copy) NSString * currentCallChannelId;
///用户的金币
@property (nonatomic, assign) NSInteger selfCoin;
///是否接通视频
@property (nonatomic, assign) BOOL isCallYes;
///是否允许录屏截屏
@property (nonatomic, assign) BOOL isRecordScreen;
///当前是否有视频卡
@property (nonatomic, assign) BOOL isShowVideoCard;
///是否已经进入主页且更新了个人信息
@property (nonatomic, assign) BOOL isUpdateUserInfo;

///阿里云oss配置
@property (nonatomic, copy) NSString * SecurityToken;
@property (nonatomic, copy) NSString * AccessKeySecret;
@property (nonatomic, copy) NSString * AccessKeyId;

///弹窗全局控制
@property (nonatomic, strong) WMZDialog * mainControlAlert;
@property (nonatomic, strong) WMZDialog * addProjectlAlert;
///当前视频通话消息id
@property (nonatomic, copy) NSString * currentCallMsgId;
///当前视频通话会话id
@property (nonatomic, copy) NSString * currentCallConversationId;

@property (nonatomic, copy) chooseImgSuccessBlock imgBlock;
@property (nonatomic, copy) finishChooseVideoBlock videoBlock;
///type 1.图片，2.视频
- (void)chooseMediaWith:(NSInteger)mediaType count:(NSInteger)count withCrop:(BOOL)crop selectImg:(chooseImgSuccessBlock)imgBlock selectVideo:(finishChooseVideoBlock)videoBlock;

- (void)chooseMediaWithSelectImg:(chooseImgSuccessBlock)imgBlock selectVideo:(finishChooseVideoBlock)videoBlock;

- (void)getAliOssInfo;

- (void)getVideoThumbnailAsync:(NSURL *)videoURL completion:(void(^)(UIImage *thumbnail))completion;

@end
