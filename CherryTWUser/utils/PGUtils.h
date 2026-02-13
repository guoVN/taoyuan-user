//
//  PGUtils.h
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import <Foundation/Foundation.h>
#import "PGLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGUtils : NSObject

/**
 设置特定文字的颜色
 @param color 搜索到的文字显示的颜色
 @param allString 显示所有文字的
 @param font 搜索到的文字显示的大小
 @param text 搜索到的文字
 */
+(NSMutableAttributedString *)setColor:(UIColor *)color
                             allString:(NSString *)allString
                                  font:(UIFont *)font
                                  text:(NSString *)text;

//时间戳转时间
+ (NSString *)ConvertsStringToTime:(NSString *)timeStr;
///时间转时间戳
+ (NSInteger)ConvertsTimeStrToTimeStamp:(NSString*)deadlineStr;
//时间戳转换为几分钟前
+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval;
//时间戳转时间（mm-dd HH:mm）
+ (NSString *)ConvertsStringToTimeYDHM:(NSString *)timeStr;

////获取当前导航
+(UIViewController *)getCurrentVC;

// 将字典或者数组转化为JSON串
+ (NSString *)objectToJson:(id)obj;
//字符串转字典或数组
+ (id)jsonToObject:(NSString *)json;
//压缩图片
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;
///图片限制提示
+ (void)showPickImageCountLimitAlertView:(NSInteger)photoCount;
///保存指定视图生成图片保存至相册
+ (void)saveImgWithView:(UIView *)imgView;
///获取设备唯一标识
+(NSString *)getAdId;
///从数组中随机取n个元素
+ (NSArray *)randomArray:(NSArray *)dataArray byLength:(NSInteger)length;
///获取ua
+(void)getUserAgent;
///获取mac地址
+(NSString *)getMacAddress;
///获取当前时间戳
+(NSString *)getCurrentTimeStamp;
///登录成功后的操作
+(void)loginSuccess:(NSDictionary *)dic;
///退出登录
+ (void)loginOut;
///更新用户信息
+ (void)getUserInfo;
+(void)updateUserInfo:(NSDictionary *)dic;
///打乱数组顺序
+ (NSArray *)getRadomArr:(NSArray *)arr;
///根据内容判断文件类型
+ (NSString * )getFileFormat:(NSString *)content;
///去充值
+ (void)goRecharge;
+ (void)goRechargeAlert;
//获取视频封面，本地视频，网络视频都可以用
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL;
///版本更新
+ (void)versionUpdate;
///去掉多余的零
+ (NSString *)removeExcessZeros:(NSString *)value;
///四舍五入保留2位小数
+ (NSString *)FloatKeepOneBits:(float)floatnum;
///去掉多余的0
+ (NSString *)formatNumber:(double)number;
///登录im
+ (void)loginIM:(PGLoginModel *)model;

@end

NS_ASSUME_NONNULL_END
