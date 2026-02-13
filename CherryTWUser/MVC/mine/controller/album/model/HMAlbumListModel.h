//
//  HMAlbumListModel.h
//  CherryTWanchor
//
//  Created by guo on 2025/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMAlbumListModel : NSObject

///审核状态 Y N
@property (nonatomic, copy) NSString * audit;
///审核人员
@property (nonatomic, copy) NSString * auditUser;
///处理时间
@property (nonatomic, copy) NSString * handleTime;
///是否初次审核
@property (nonatomic, copy) NSString * initialAudit;
///Y:动态，N:非动态
@property (nonatomic, copy) NSString * isDynamic;
///审核管理员 审核结果 0:未审核 1:审核通过 2:审核驳回
@property (nonatomic, copy) NSString * leaderAudit;
///审核管理员驳回原因
@property (nonatomic, copy) NSString * leaderRefuseContent;
/// 用户昵称
@property (nonatomic, copy) NSString * nickName;
/// 包名
@property (nonatomic, copy) NSString * packName;
///用户签名
@property (nonatomic, copy) NSString * personalSign;
@property (nonatomic, copy) NSString * photoUrl;
@property (nonatomic, copy) NSString * photoid;
///拒审文案
@property (nonatomic, copy) NSString * refuseContent;
///上传时间
@property (nonatomic, copy) NSString * submitTime;
///公会ID
@property (nonatomic, copy) NSString * unionId;
///公会昵称
@property (nonatomic, copy) NSString * unionName;
@property (nonatomic, copy) NSString * userid;
/// 任务有效期
@property (nonatomic, copy) NSString * validTime;

@end

NS_ASSUME_NONNULL_END
