//
//  PGAPIService.h
//  CherryTWUser
//
//  Created by guo on 2024/12/10.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGAPIService : NSObject

///应用首次启动获取channelNo
+ (void)checkChannelNoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                         failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///检测手机号是否注册
+ (void)checkPhoneWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///发送验证码
+ (void)sendMsgCodeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///通用配置获取，头像生成，客服，提现费率
+ (void)getUserDefaultHeadImgWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///手机号登录
+ (void)phoneLoginWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///用户注册
+ (void)userRegisterWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///上传图片
+ (void)uploadFileWithImages:(NSArray<UIImage *> *)image Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///视频上传
+ (void)uploadVideoFileWithImages:(NSArray<NSURL *> *)video Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///首页推荐列表
+ (void)homeRemandWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///主播详情
+ (void)anchorDetailWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///查询是否关注了对方
+ (void)checkCollectStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///查询拉黑状态
+ (void)checkBlackenedWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///拉黑
+ (void)blackAddWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;
///取消拉黑
+ (void)cancelBlackActionWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                                failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 举报
+ (void)reportWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///收藏
+ (void)collectAddWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///取消收藏
+ (void)collectCancelWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///根据id搜索主播
+ (void)searchAnchorWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取用户信息
+ (void)getUserInfoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///修改头像
+ (void)updateHeadImgWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///修改昵称
+ (void)updateNickNameWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///修改年龄
+ (void)updateAgeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///修改身高
+ (void)updateTallWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///修改体重
+ (void)updateWeightWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///收藏列表
+ (void)myCollectListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///我的动态列表
+ (void)myDynamicListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///女主播动态列表
+ (void)anchorDynamicListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取绑定的邀请码
+ (void)getBindInviteCodeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///补填邀请码
+ (void)writeInviteCodeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///注销账号
+ (void)logOffWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///退出登录
+ (void)logOutWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///添加相册
+ (void)addPhotoToAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///我的相册
+ (void)myAlbumListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 删除相册照片
+ (void)deleteAlbumPhotoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 动态tab列表
+ (void)dynamicListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 删除动态
+ (void)deleteDynamicWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 动态发布
+ (void)publishDynamicWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 动态通知，详情
+ (void)dynamicDetailAndNoticeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 查看动态通知
+ (void)checkDynamicNoticeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 动态点赞
+ (void)dynamicPraiseWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 钻石列表
+ (void)diamondListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 支付列表
+ (void)payListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 支付判断走原生还是三方
+ (void)payOriginOrThirdWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 支付充值
+ (void)payRechargeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 获取邀请码及邀请链接
+ (void)getInviteCodeAndLinkWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 我的邀请列表
+ (void)myInviteListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 我的收益列表
+ (void)myIncomeListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 赠送礼物
+ (void)sendGiftWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///下载
+ (void)downFileWithUrl:(NSString *)url filePath:(NSString *)path Success:(void (^)(id data))successBlock
                failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///上传语音
+ (void)uploadFileWithAudio:(NSString *)filePath Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///用户10s内未接听视频卡或者主动关闭视频的情况下调用
+ (void)userRefuseVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 视频通话前预请求
+ (void)videoCheckPreChargingWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 获取主动拨打视频的资费
+ (void)videoUserPublishWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 视频通话扣费(首次接通，到配置首次扣费时间，然后每隔一分钟，到视频结束都要请求)
+ (void)videoChargingWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 视频通过结束
+ (void)videoFinishWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 启动图配置
+ (void)launchScreenConfigWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 消息发送添加记录
+ (void)messageSendAddRecordWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 女端给男端打视频接通或拒绝
+ (void)callVideoManStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///修改在线状态
+ (void)updateUserStateWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///心跳接口
+ (void)heartWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///开启忙碌
+ (void)startBusyStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///关闭忙碌
+ (void)endBusyStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///版本更新
+ (void)versionUpdateWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///提现账户列表
+ (void)withdrawListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///删除某个提现账户
+ (void)deleteWithdrawAccountWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///添加提现账户
+ (void)addWithdrawAccountWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///提现明细
+ (void)getWithdrawRecordWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取积分余额
+ (void)jiFenBalanceWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取当前用户余额
+ (void)userBalanceWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///一键转入到账户
+ (void)transferToAccountWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///提现操作(支付宝)
+ (void)withdrawalActionWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取女主播通话价格
+ (void)getCallPriceWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取录屏截屏开关
+ (void)getScreenRecordSwitchWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///普通消息扣费
+ (void)messageChargeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取声网token
+ (void)getAgroaTokenWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///aws文件上传
+ (void)fileAwsUploadWithParameters:(NSDictionary *)parametersDic fileData:(NSData *)fileData mimeType:(NSString *)mimeType Success:(void (^)(id data))successBlock
                            failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///首页轮播图
+ (void)homeBannerWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///女主播预约详情
+ (void)yuYueDetailWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///查询女主播项目
+ (void)checkAnchorProjectWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///确认预约
+ (void)sureYuYueWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///查询未使用预约单
+ (void)checkNoUseYuYueOrderWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///查询聊天解锁
+ (void)checkChatLockWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///解锁聊天
+ (void)updateChatLockWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 个人中心粉丝数和关注数
+ (void)fansAndFollowNumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                               failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///粉丝列表
+ (void)fansListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                       failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///关注列表
+ (void)followListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                         failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///取消关注
+ (void)cancelAttentionWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                              failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///查询预约记录
+ (void)checkYuyueRecordLsitWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取邀请码链接信息
+ (void)getInviteInfoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///黑名单列表
+ (void)blackListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

///获取阿里云配置
+ (void)getAliOSSInfoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 我的相册
+ (void)myAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 上传到相册
+ (void)uploadPhotoToAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 删除相册照片
+ (void)deletePhotoAtAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                                 failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 我的视频
+ (void)myVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 上传到视频
+ (void)uploadVideoToVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

/// 删除视频
+ (void)deleteVideoAtVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock;

@end

NS_ASSUME_NONNULL_END
