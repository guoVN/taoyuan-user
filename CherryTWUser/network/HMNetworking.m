//
//  HMNetworking.m
//  CherryTWanchor
//
//  Created by guo on 2025/8/22.
//

#import "HMNetworking.h"
#import <objc/runtime.h>

// 日志开关（发布环境设为0关闭）
#define HTTP_LOG_ENABLED 1

// 日志类型枚举
typedef NS_ENUM(NSInteger, HTTPLogType) {
    HTTPLogTypeRequest,  // 请求日志
    HTTPLogTypeResponse  // 响应日志
};

@interface HMNetworking () <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionTask *> *tasks;
@property (nonatomic, strong) NSOperationQueue *delegateQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *globalHeaders;
@end

@implementation HMNetworking

+ (instancetype)sharedClient {
    static HMNetworking *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[HMNetworking alloc] init];
    });
    return client;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化会话配置
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 30; // 请求超时时间
        config.HTTPMaximumConnectionsPerHost = 10; // 最大并发连接数
        
        // 初始化队列
        self.delegateQueue = [[NSOperationQueue alloc] init];
        self.delegateQueue.maxConcurrentOperationCount = 1;
        
        // 初始化会话
        self.session = [NSURLSession sessionWithConfiguration:config
                                                     delegate:self
                                                delegateQueue:self.delegateQueue];
        
        // 初始化任务字典
        self.tasks = [NSMutableDictionary dictionary];
        
        // 初始化全局请求头
        self.globalHeaders = [NSMutableDictionary dictionary];
        // 默认表单类型，可被覆盖
        self.globalHeaders[@"Content-Type"] = @"application/x-www-form-urlencoded";
        
        // 初始化默认可接受的内容类型
        self.defaultAcceptContentTypes = @[
            @"text/html",
            @"application/json",
            @"text/javascript",
            @"text/json",
            @"text/plain"
        ];
    }
    return self;
}

#pragma mark - GET 请求
- (NSURLSessionDataTask *)get:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      headers:(NSDictionary<NSString *, NSString *> *)headers
                      success:(HTTPJSONSuccessBlock)success
                      failure:(HTTPFailureBlock)failure {
    // 拼接URL和参数
    NSString *fullURL = [self urlStringWithBaseURL:url parameters:parameters];
    NSURL *requestURL = [NSURL URLWithString:fullURL];
    if (!requestURL) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:@"HTTPClient"
                                                 code:-1001
                                             userInfo:@{NSLocalizedDescriptionKey: @"无效的URL"}];
            
            failure(error);
        }
        return nil;
    }
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"GET";
    
    // 设置请求头（全局+局部，局部覆盖全局）
    [self setupHeaders:request withCustomHeaders:headers];
    
    // 创建任务
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
       // 解析响应数据用于日志
       id jsonResponse = nil;
       if (!error && data.length > 0) {
           jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
       }
       
       // 打印响应日志
       [self logWithType:HTTPLogTypeResponse
                     url:fullURL
                  method:@"GET"
              parameters:parameters
                 headers:headers
                response:jsonResponse
                   error:error];
        
        [self handleJSONResponse:response data:data error:error success:success failure:failure];
    }];
    
    // 保存任务
    [self.tasks setObject:task forKey:fullURL];
    
    // 启动任务
    [task resume];
    
    return task;
}

#pragma mark - POST 请求
- (NSURLSessionDataTask *)postForm:(NSString *)url
                         parameters:(NSDictionary *)parameters
                            headers:(NSDictionary<NSString *, NSString *> *)headers
                            success:(HTTPJSONSuccessBlock)success
                            failure:(HTTPFailureBlock)failure {
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:@"HTTPClient"
                                                 code:-1001
                                             userInfo:@{NSLocalizedDescriptionKey: @"无效的URL"}];
            failure(error);
        }
        return nil;
    }
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"POST";
    
    // 设置请求头（全局+局部）
    [self setupHeaders:request withCustomHeaders:headers];
    
    // 处理表单参数
    if (parameters) {
        request.HTTPBody = [self parametersToFormData:parameters];
    }
    
    // 创建任务
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
        id jsonResponse = nil;
        if (!error && data.length > 0) {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        
        [self logWithType:HTTPLogTypeResponse
                      url:url
                   method:@"POST"
               parameters:parameters
                  headers:headers
                 response:jsonResponse
                    error:error];
        
        [self handleJSONResponse:response data:data error:error success:success failure:failure];
    }];
    
    // 保存任务
    [self.tasks setObject:task forKey:url];
    
    // 启动任务
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)postBody:(NSString *)url
                           bodyData:(NSData *)bodyData
                            headers:(NSDictionary<NSString *, NSString *> *)headers
                            success:(HTTPJSONSuccessBlock)success
                            failure:(HTTPFailureBlock)failure {
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:@"HTTPClient"
                                                 code:-1001
                                             userInfo:@{NSLocalizedDescriptionKey: @"无效的URL"}];
            failure(error);
        }
        return nil;
    }
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"POST";
    
    // 设置请求头（全局+局部）
    [self setupHeaders:request withCustomHeaders:headers];
    
    // 设置自定义请求体
    request.HTTPBody = bodyData;
    
    // 创建任务
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
        id jsonResponse = nil;
        if (!error && data.length > 0) {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        
        [self logWithType:HTTPLogTypeResponse
                      url:url
                   method:@"POST"
               parameters:nil
                  headers:headers
                 response:jsonResponse
                    error:error];
        
        [self handleJSONResponse:response data:data error:error success:success failure:failure];
    }];
    
    // 保存任务
    [self.tasks setObject:task forKey:url];
    
    // 启动任务
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)postJSON:(NSString *)url
                         parameters:(NSDictionary *)parameters
                            headers:(NSDictionary<NSString *, NSString *> *)headers success:(HTTPJSONSuccessBlock)success
                           failure:(HTTPFailureBlock)failure {
    // 创建自定义headers，指定JSON类型
    NSMutableDictionary *jsonHeaders = [NSMutableDictionary dictionaryWithDictionary:headers ?: @{}];
    jsonHeaders[@"Content-Type"] = @"application/json";
    
    // 转换参数为JSON数据
    NSData *jsonData = nil;
    NSError *error;
    if (parameters) {
        jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:0
                                                     error:&error];
        if (error) {
            return nil;
        }
    }
    
    // 调用自定义body的POST方法
    return [self postBody:url bodyData:jsonData headers:jsonHeaders success:success failure:failure];
}

#pragma mark - 文件上传
- (NSURLSessionUploadTask *)upload:(NSString *)url
                         parameters:(NSDictionary *)parameters
                           fileData:(NSData *)fileData
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                               name:(NSString *)name
                             headers:(NSDictionary<NSString *, NSString *> *)headers
                             progress:(HTTPProgressBlock)progress
                              success:(HTTPJSONSuccessBlock)success
                              failure:(HTTPFailureBlock)failure {
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:@"HTTPClient"
                                                 code:-1001
                                             userInfo:@{NSLocalizedDescriptionKey: @"无效的URL"}];
            failure(error);
        }
        return nil;
    }
    
    // 创建表单数据
    NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
    NSMutableData *formData = [NSMutableData data];
    
    // 添加普通参数
    if (parameters) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [formData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [formData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [formData appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }
    
    // 添加文件参数
    if (fileData && fileName && mimeType && name) {
        [formData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [formData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [formData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [formData appendData:fileData];
        [formData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // 结束表单
    [formData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"POST";
    
    // 设置请求头（全局+局部，表单类型会覆盖Content-Type）
    NSMutableDictionary *uploadHeaders = [NSMutableDictionary dictionaryWithDictionary:headers ?: @{}];
    uploadHeaders[@"Content-Type"] = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [self setupHeaders:request withCustomHeaders:uploadHeaders];
    
    // 创建上传任务
    NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:request
                                                              fromData:formData
                                                     completionHandler:^(NSData * _Nullable data,
                                                                         NSURLResponse * _Nullable response,
                                                                         NSError * _Nullable error) {
       id jsonResponse = nil;
       if (!error && data.length > 0) {
           jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
       }
       
       [self logWithType:HTTPLogTypeResponse
                     url:url
                  method:@"POST"
              parameters:parameters
                 headers:headers
                response:jsonResponse
                   error:error];
        
        [self handleJSONResponse:response data:data error:error success:success failure:failure];
    }];
    
    // 保存任务
    [self.tasks setObject:task forKey:url];
    
    // 启动任务
    [task resume];
    
    // 进度回调
    if (progress) {
        [task addObserver:self
                forKeyPath:@"progress.fractionCompleted"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
        objc_setAssociatedObject(task, @selector(upload:parameters:fileData:fileName:mimeType:name:headers:progress:success:failure:), progress, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return task;
}

#pragma mark - 文件下载
- (NSURLSessionDownloadTask *)download:(NSString *)url
                               savePath:(NSString *)savePath
                                headers:(NSDictionary<NSString *, NSString *> *)headers
                                progress:(HTTPProgressBlock)progress
                                 success:(void (^)(NSString *))success
                                 failure:(HTTPFailureBlock)failure {
    NSURL *requestURL = [NSURL URLWithString:url];
    if (!requestURL) {
        if (failure) {
            NSError *error = [NSError errorWithDomain:@"HTTPClient"
                                                 code:-1001
                                             userInfo:@{NSLocalizedDescriptionKey: @"无效的URL"}];
            failure(error);
        }
        return nil;
    }
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"GET";
    
    // 设置请求头（全局+局部）
    [self setupHeaders:request withCustomHeaders:headers];
    
    // 创建下载任务
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request
                                                           completionHandler:^(NSURL * _Nullable location,
                                                                               NSURLResponse * _Nullable response,
                                                                               NSError * _Nullable error) {
        if (error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
            return;
        }
        
        // 确保保存路径存在
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:savePath]) {
            [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
                return;
            }
        }
        
        // 获取文件名
        NSString *fileName = [response suggestedFilename];
        if (!fileName) {
            fileName = [url lastPathComponent];
        }
        
        // 完整保存路径
        NSString *filePath = [savePath stringByAppendingPathComponent:fileName];
        
        // 移动临时文件到目标路径
        if ([fileManager fileExistsAtPath:filePath]) {
            [fileManager removeItemAtPath:filePath error:&error];
        }
        BOOL successMove = [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:&error];
        
        if (successMove) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(filePath);
                });
            }
        } else {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        }
    }];
    
    // 保存任务
    [self.tasks setObject:task forKey:url];
    
    // 启动任务
    [task resume];
    
    // 进度回调
    if (progress) {
        [task addObserver:self
                forKeyPath:@"progress.fractionCompleted"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
        objc_setAssociatedObject(task, @selector(download:savePath:headers:progress:success:failure:), progress, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    return task;
}

#pragma mark - 取消请求
- (void)cancelAllRequests {
    [self.tasks enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSURLSessionTask *task, BOOL *stop) {
        [task cancel];
    }];
    [self.tasks removeAllObjects];
}

- (void)cancelRequestWithURL:(NSString *)url {
    NSURLSessionTask *task = [self.tasks objectForKey:url];
    if (task) {
        [task cancel];
        [self.tasks removeObjectForKey:url];
    }
}

#pragma mark - 私有方法
/// 拼接URL和参数
- (NSString *)urlStringWithBaseURL:(NSString *)baseURL parameters:(NSDictionary *)parameters {
    if (!parameters || parameters.count == 0) {
        return baseURL;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithString:baseURL];
    if ([baseURL rangeOfString:@"?"].location == NSNotFound) {
        [urlString appendString:@"?"];
    } else {
        [urlString appendString:@"&"];
    }
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        NSString *encodedKey = [self urlEncode:key];
        NSString *encodedValue = [self urlEncode:[NSString stringWithFormat:@"%@", value]];
        [urlString appendFormat:@"%@=%@&", encodedKey, encodedValue];
    }];
    
    // 移除最后一个&
    if (urlString.length > 0 && [urlString characterAtIndex:urlString.length - 1] == '&') {
        urlString = [NSMutableString stringWithString:[urlString substringToIndex:urlString.length - 1]];
    }
    
    return urlString;
}

/// 参数转表单数据
- (NSData *)parametersToFormData:(NSDictionary *)parameters {
    if (!parameters || parameters.count == 0) {
        return nil;
    }
    
    NSMutableString *paramString = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        NSString *encodedKey = [self urlEncode:key];
        NSString *encodedValue = [self urlEncode:[NSString stringWithFormat:@"%@", value]];
        [paramString appendFormat:@"%@=%@&", encodedKey, encodedValue];
    }];
    
    // 移除最后一个&
    if (paramString.length > 0 && [paramString characterAtIndex:paramString.length - 1] == '&') {
        paramString = [NSMutableString stringWithString:[paramString substringToIndex:paramString.length - 1]];
    }
    
    return [paramString dataUsingEncoding:NSUTF8StringEncoding];
}

/// URL编码
- (NSString *)urlEncode:(NSString *)string {
    if (!string) {
        return @"";
    }
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ?: @"";
}

/// 处理响应并解析JSON
- (void)handleJSONResponse:(NSURLResponse *)response
                      data:(NSData *)data
                     error:(NSError *)error
                   success:(HTTPJSONSuccessBlock)success
                   failure:(HTTPFailureBlock)failure {
    WeakSelf(self)
    // 切换到主线程回调
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        
        // 检查HTTP响应状态码
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSError *httpError = [NSError errorWithDomain:@"HTTPClient"
                                                    code:httpResponse.statusCode
                                                userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"HTTP错误: %ld", (long)httpResponse.statusCode]}];
            if (failure) {
                failure(httpError);
            }
            return;
        }
        
        // 解析JSON数据
        if (data.length == 0) {
            // 空数据也视为成功（返回nil）
            if (success) {
                success(nil);
            }
            return;
        }
        
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:&jsonError];
        
        if (jsonError) {
            if (failure) {
                failure(jsonError);
            }
        } else {
            if (success) {
                success(jsonObject);
                [weakself loginOffJudge:jsonObject];
            }
        }
    });
}

/// 设置请求头（合并全局和局部headers，局部覆盖全局）
- (void)setupHeaders:(NSMutableURLRequest *)request withCustomHeaders:(NSDictionary<NSString *, NSString *> *)customHeaders {
    // 1. 处理Accept头（默认+局部）
    NSMutableArray *acceptTypes = [self.defaultAcceptContentTypes mutableCopy];
    
    // 如果局部headers有自定义Accept，优先使用局部
    if (customHeaders[@"Accept"]) {
        acceptTypes = [NSMutableArray arrayWithObject:customHeaders[@"Accept"]];
    }
    
    // 拼接Accept字符串（格式："text/html,application/json,...;charset=UTF-8"）
    NSString *acceptHeader = [acceptTypes componentsJoinedByString:@","];
    acceptHeader = [acceptHeader stringByAppendingString:@";charset=UTF-8"];
    
    // 2. 先添加全局headers
    [self.globalHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    // 3. 设置Accept头（会覆盖全局中可能存在的Accept）
    [request setValue:acceptHeader forHTTPHeaderField:@"Accept"];
    
    // 4. 最后添加局部headers（局部其他头会覆盖全局）
    if (customHeaders) {
        [customHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            // 跳过Accept，已单独处理
            if ([key isEqualToString:@"Accept"]) return;
            [request setValue:value forHTTPHeaderField:key];
        }];
    }
}

#pragma mark - KVO 进度监听
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"progress.fractionCompleted"] && [object isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask *task = (NSURLSessionTask *)object;
        float progress = [change[NSKeyValueChangeNewKey] floatValue];
        
        // 获取关联的进度回调
        HTTPProgressBlock progressBlock = objc_getAssociatedObject(task, @selector(upload:parameters:fileData:fileName:mimeType:name:headers:progress:success:failure:));
        if (!progressBlock) {
            progressBlock = objc_getAssociatedObject(task, @selector(download:savePath:headers:progress:success:failure:));
        }
        
        // 主线程回调
        if (progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock(progress);
            });
        }
        
        // 进度完成后移除监听
        if (progress >= 1.0f) {
            [task removeObserver:self forKeyPath:keyPath];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 核心日志方法（统一处理所有日志）
- (void)logWithType:(HTTPLogType)type
                url:(NSString *)url
             method:(NSString *)method
         parameters:(id)parameters
            headers:(NSDictionary *)headers
           response:(id)response
              error:(NSError *)error {
#if HTTP_LOG_ENABLED
    dispatch_async(dispatch_get_main_queue(), ^{
        // 日志头部
        NSString *logHeader = (type == HTTPLogTypeRequest) ?
        @"------------------- 网络请求开始 -------------------" :
        @"------------------- 网络响应开始 -------------------";
        
        // 日志尾部
        NSString *logFooter = @"---------------------------------------------------";
        
        // 拼接日志内容
        NSMutableString *logString = [NSMutableString stringWithFormat:@"%@\n", logHeader];
        [logString appendFormat:@"请求URL: %@\n", url ?: @"未知URL"];
        [logString appendFormat:@"请求方法: %@\n", method ?: @"未知方法"];
        
        // 根据日志类型添加不同内容
        if (type == HTTPLogTypeRequest) {
            // 请求日志：添加头信息和参数
            if (headers && headers.count > 0) {
                [logString appendFormat:@"请求头: %@\n", headers];
            }
            if (parameters) {
                [logString appendFormat:@"请求参数: %@\n", parameters];
            }
        } else {
            // 请求日志：添加头信息和参数
            if (headers && headers.count > 0) {
                [logString appendFormat:@"请求头: %@\n", headers];
            }
            if (parameters) {
                [logString appendFormat:@"请求参数: %@\n", parameters];
            }
            // 响应日志：添加响应数据或错误信息
            if (error) {
                [logString appendFormat:@"响应错误: %@\n", error.localizedDescription];
                [logString appendFormat:@"错误详情: %@\n", error.userInfo];
            } else if (response) {
//                [logString appendFormat:@"响应数据: %@\n", response];
               NSError *error = nil;
               NSData *jsonData = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
               if (jsonData && !error) {
                   NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                   [logString appendFormat:@"响应数据: %@\n", jsonStr];
               } else {
                   [logString appendFormat:@"响应数据：JSON 转字符串失败：%@\n", error.localizedDescription];
               }
            } else {
                [logString appendString:@"响应数据: 空\n"];
            }
        }
        
        [logString appendString:logFooter];
        
        // 打印日志
        NSLog(@"%@", logString);
    });
#endif
}

#pragma mark - 销毁
- (void)dealloc {
    [self.session invalidateAndCancel];
    [self.tasks enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSURLSessionTask *task, BOOL *stop) {
        [task removeObserver:self forKeyPath:@"progress.fractionCompleted"];
    }];
}

#pragma mark===退出登录拦截
- (void)loginOffJudge:(id)responseObject
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([responseObject[@"code"] integerValue] == 401) {
            [QMUITips showWithText:Localized(@"登录已失效，请重新登录")];
            if ([[PGManager shareModel].userInfo.userid integerValue] == 0) {
                [PGUtils loginOut];
                return;
            }
            [PGAPIService logOutWithParameters:@{@"userid":[PGManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
                [PGUtils loginOut];
            } failure:^(NSInteger code, NSString * _Nonnull message) {
                [PGUtils loginOut];
            }];
            return;
        }
    }
}

@end

