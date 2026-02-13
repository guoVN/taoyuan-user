//
//  HMNetworking.h
//  CherryTWanchor
//
//  Created by guo on 2025/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  JSON 成功回调
 *  @param responseObject 解析后的 JSON 数据（NSDictionary 或 NSArray）
 */
typedef void(^HTTPJSONSuccessBlock)(id _Nullable responseObject);

/**
 *  失败回调
 *  @param error 错误信息
 */
typedef void(^HTTPFailureBlock)(NSError * _Nonnull error);

/**
 *  进度回调
 *  @param progress 进度值（0.0 ~ 1.0）
 */
typedef void(^HTTPProgressBlock)(float progress);

@interface HMNetworking : NSObject

/**
 *  单例
 */
+ (instancetype _Nonnull)sharedClient;

/**
 *  全局请求头（所有请求都会带上）
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> * _Nonnull globalHeaders;

/**
 *  全局可接受的内容类型（默认包含常用类型）
 */
@property (nonatomic, strong) NSArray<NSString *> * defaultAcceptContentTypes;

#pragma mark - GET 请求
/**
 *  GET 请求
 *  @param url        请求地址
 *  @param parameters 请求参数
 *  @param headers    局部请求头（会覆盖全局同名 header）
 *  @param success    成功回调（返回解析后的 JSON）
 *  @param failure    失败回调
 *  @return 请求任务
 */
- (NSURLSessionDataTask * _Nullable)get:(NSString * _Nonnull)url
                             parameters:(NSDictionary * _Nullable)parameters
                                headers:(NSDictionary<NSString *, NSString *> * _Nullable)headers
                                success:(HTTPJSONSuccessBlock _Nullable)success
                                failure:(HTTPFailureBlock _Nullable)failure;

#pragma mark - POST 请求
/**
 *  POST 表单请求（application/x-www-form-urlencoded）
 *  @param url        请求地址
 *  @param parameters 请求参数（字典会转为表单格式）
 *  @param headers    局部请求头
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @return 请求任务
 */
- (NSURLSessionDataTask * _Nullable)postForm:(NSString * _Nonnull)url
                                  parameters:(NSDictionary * _Nullable)parameters
                                     headers:(NSDictionary<NSString *, NSString *> * _Nullable)headers
                                     success:(HTTPJSONSuccessBlock _Nullable)success
                                     failure:(HTTPFailureBlock _Nullable)failure;

/**
 *  POST 自定义 Body 请求
 *  @param url        请求地址
 *  @param bodyData   自定义请求体数据
 *  @param headers    局部请求头（需指定正确的 Content-Type）
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @return 请求任务
 */
- (NSURLSessionDataTask * _Nullable)postBody:(NSString * _Nonnull)url
                                    bodyData:(NSData * _Nullable)bodyData
                                     headers:(NSDictionary<NSString *, NSString *> * _Nullable)headers
                                     success:(HTTPJSONSuccessBlock _Nullable)success
                                     failure:(HTTPFailureBlock _Nullable)failure;

/**
 *  POST JSON 请求（application/json）
 *  @param url        请求地址
 *  @param parameters JSON 参数（字典会转为 JSON 字符串）
 *  @param headers    局部请求头
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @return 请求任务
 */
- (NSURLSessionDataTask * _Nullable)postJSON:(NSString * _Nonnull)url
                                  parameters:(NSDictionary * _Nullable)parameters
                                     headers:(NSDictionary<NSString *, NSString *> * _Nullable)headers
                                     success:(HTTPJSONSuccessBlock _Nullable)success
                                     failure:(HTTPFailureBlock _Nullable)failure;

#pragma mark - 文件上传
/**
 *  文件上传（multipart/form-data）
 *  @param url        上传地址
 *  @param parameters 普通参数
 *  @param fileData   文件数据
 *  @param fileName   文件名（如 "image.jpg"）
 *  @param mimeType   文件类型（如 "image/jpeg"）
 *  @param name       表单字段名（后端接收的 key）
 *  @param headers    局部请求头
 *  @param progress   进度回调
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @return 上传任务
 */
- (NSURLSessionUploadTask * _Nullable)upload:(NSString * _Nonnull)url
                                  parameters:(NSDictionary * _Nullable)parameters
                                    fileData:(NSData * _Nonnull)fileData
                                    fileName:(NSString * _Nonnull)fileName
                                    mimeType:(NSString * _Nonnull)mimeType
                                        name:(NSString * _Nonnull)name
                                      headers:(NSDictionary<NSString *, NSString *> * _Nullable)headers
                                      progress:(HTTPProgressBlock _Nullable)progress
                                       success:(HTTPJSONSuccessBlock _Nullable)success
                                       failure:(HTTPFailureBlock _Nullable)failure;

#pragma mark - 文件下载
/**
 *  文件下载
 *  @param url        下载地址
 *  @param savePath   保存目录路径（如 Document 下的 "downloads" 文件夹）
 *  @param headers    局部请求头
 *  @param progress   进度回调
 *  @param success    成功回调（返回文件保存路径）
 *  @param failure    失败回调
 *  @return 下载任务
 */
- (NSURLSessionDownloadTask * _Nullable)download:(NSString * _Nonnull)url
                                        savePath:(NSString * _Nonnull)savePath
                                         headers:(NSDictionary<NSString *, NSString *> * _Nullable)headers
                                         progress:(HTTPProgressBlock _Nullable)progress
                                          success:(void(^ _Nullable)(NSString * _Nonnull filePath))success
                                          failure:(HTTPFailureBlock _Nullable)failure;

#pragma mark - 取消请求
/**
 *  取消所有请求
 */
- (void)cancelAllRequests;

/**
 *  取消指定 URL 的请求
 *  @param url 请求地址
 */
- (void)cancelRequestWithURL:(NSString * _Nonnull)url;

@end

NS_ASSUME_NONNULL_END
