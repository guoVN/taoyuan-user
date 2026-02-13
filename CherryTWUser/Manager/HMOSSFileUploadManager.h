//
//  HMOSSFileUploadManager.h
//  CherryTWanchor
//
//  Created by guo on 2025/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};
// 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
typedef void(^HMUploadImageManageProgressBlock)(int64_t bytesSent, int64_t totalByteSent ,int64_t totalBytesExpectedToSend);

@interface HMOSSFileUploadManager : NSObject

//异步上传单张图片
+ (void)asyncUploadImage:(UIImage *)image progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete;
//同步上传单张图片
+ (void)syncUploadImage:(UIImage *)image progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete;
//异步上传多张图片
+ (void)asyncUploadImages:(NSArray<UIImage *> *)images progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;
//同步上传多张图片
+ (void)syncUploadImages:(NSArray<UIImage *> *)images  progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;
//异步单个上传视频
+ (void)asyncUploadVideo:(NSData *)data progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;
//同步单个上传视频
+ (void)syncUploadVideo:(NSData *)data progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;
//异步多个上传视频
+ (void)asyncUploadVideos:(NSArray<NSURL *> *)videoArr progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;
//同步多个上传视频
+ (void)syncUploadVideos:(NSArray<NSURL *> *)videoArr progress:(HMUploadImageManageProgressBlock)progressBlock complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;

@end

NS_ASSUME_NONNULL_END
