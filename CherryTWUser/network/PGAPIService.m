//
//  PGAPIService.m
//  CherryTWUser
//
//  Created by guo on 2024/12/10.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGAPIService.h"
#import "HMOSSFileUploadManager.h"

///测试环境
#define BaseUrl @"https://test.hainanyihong.cn/chatserver"
///正式环境
//#define BaseUrl @"http://newm.huayuan123.com/chatserver"

@implementation PGAPIService

+ (NSDictionary *)getCommonHeaderOfSubclasses:(NSDictionary *)paramDic {
    NSString *timeStampString = [PGUtils getCurrentTimeStamp];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    token = token.length > 0 ? token : @"";
    NSMutableDictionary *dicM = @{@"UTOKEN":token,@"appPackageName":Package_Name,@"versionCode":versionCode, @"channelName":Channel_Name,@"ts":timeStampString,@"isNewMale":@"true",@"appType":@"ios"}.mutableCopy;
    NSString * sign = [PGParameterSignTool encoingWithDic:[NSMutableDictionary dictionaryWithDictionary:paramDic] andTimeSta:timeStampString];
    [dicM setValue:sign forKey:@"chatSign"];
    return dicM;
}

///应用首次启动获取channelNo
+ (void)checkChannelNoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                         failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/activation/info/flow"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///检测手机号是否注册
+ (void)checkPhoneWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/get/user"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///发送验证码
+ (void)sendMsgCodeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                            failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/sms/send"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///通用配置获取，头像生成，客服，提现费率
+ (void)getUserDefaultHeadImgWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/paramConfigV2/getParamConfigValue"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///手机号登录
+ (void)phoneLoginWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/phone/login"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///用户注册
+ (void)userRegisterWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/p6/flow/register"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///上传图片
+ (void)uploadFileWithImages:(NSArray<UIImage *> *)image Success:(void (^)(id data))successBlock
                            failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    [HMOSSFileUploadManager asyncUploadImages:image progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            
    } complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
        if (state == UploadImageSuccess) {
//            NSMutableArray * imageArr = [NSMutableArray array];
//            for (NSInteger i=0; i<names.count; i++) {
//                NSDictionary * dic = @{@"fullurl":names[i]};
//                [imageArr addObject:dic];
//            }
            NSDictionary * dataDic = @{@"data":names};
            successBlock(dataDic);
        }else{
            failureBlock(50000,Localized(@"Network error"));
            [[PGManager shareModel] getAliOssInfo];
        }
    }];
/*
    // 1. 初始化总数量和计数器（需线程安全，避免多线程竞争）
        NSInteger totalCount = image.count;
        __block NSInteger completedCount = 0;
        __block NSMutableArray *allResults = [NSMutableArray arrayWithCapacity:totalCount]; // 存储所有上传结果
        NSLock *lock = [[NSLock alloc] init]; // 用于计数器同步
    
    for (UIImage * img in image) {
        NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
        [self fileAwsUploadWithParameters:@{} fileData:imageData mimeType:@"jpg" Success:^(id  _Nonnull data) {
            [lock lock]; // 加锁，确保计数器操作线程安全
            completedCount++;
            [allResults addObject:data]; // 存储当前上传结果
            // 3. 检查是否所有任务都已完成
            if (completedCount == totalCount) {
                [lock unlock]; // 先解锁再回调（避免回调中耗时操作阻塞锁）
                if (successBlock) {
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
                    [dataDic setValue:@"0" forKey:@"code"];
                    [dataDic setValue:@"1" forKey:@"success"];
                    NSMutableArray * imgStrArr = [NSMutableArray array];
                    for (NSDictionary * dd in allResults) {
                        NSDictionary * urlDic = dd[@"data"];
                        [imgStrArr addObject:urlDic[@"url"]];
                    }
                    [dataDic setValue:imgStrArr forKey:@"data"];
                    successBlock(dataDic); // 返回所有结果
                }
            } else {
                [lock unlock];
            }
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [lock lock];
            completedCount++;
            [allResults addObject:@{@"code": @(code), @"msg": message}]; // 存储错误信息
            if (completedCount == totalCount) {
                [lock unlock];
                // 业务逻辑：若只要有一个失败则整体视为失败（可根据需求调整）
                if (failureBlock) {
                    failureBlock(code, message);
                }
            } else {
                [lock unlock];
            }
        }];
    }
 */
}

///视频上传
+ (void)uploadVideoFileWithImages:(NSArray<NSURL *> *)video Success:(void (^)(id data))successBlock
                     failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    [HMOSSFileUploadManager asyncUploadVideos:video progress:^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        
    } complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
        if (state == UploadImageSuccess) {
//            NSMutableArray * imageArr = [NSMutableArray array];
//            for (NSInteger i=0; i<names.count; i++) {
//                NSDictionary * dic = @{@"fullurl":names[i]};
//                [imageArr addObject:dic];
//            }
            NSDictionary * dataDic = @{@"data":names};
            successBlock(dataDic);
        }else{
            failureBlock(50000,Localized(@"Network error"));
            [[PGManager shareModel] getAliOssInfo];
        }
    }];
  
    /*
    // 1. 初始化总数量和计数器（需线程安全，避免多线程竞争）
    NSInteger totalCount = video.count;
    __block NSInteger completedCount = 0;
    __block NSMutableArray *allResults = [NSMutableArray arrayWithCapacity:totalCount]; // 存储所有上传结果
    NSLock *lock = [[NSLock alloc] init]; // 用于计数器同步
    
    for (NSURL * videoUrl in video) {
        NSError * error = nil;
        NSData * videoData = [NSData dataWithContentsOfURL:videoUrl
                                                 options:NSDataReadingMappedIfSafe // 优化大文件读取性能
                                                   error:&error];
        [self fileAwsUploadWithParameters:@{} fileData:videoData mimeType:@"mp4" Success:^(id  _Nonnull data) {
            [lock lock]; // 加锁，确保计数器操作线程安全
            completedCount++;
            [allResults addObject:data]; // 存储当前上传结果
            // 3. 检查是否所有任务都已完成
            if (completedCount == totalCount) {
                [lock unlock]; // 先解锁再回调（避免回调中耗时操作阻塞锁）
                if (successBlock) {
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
                    [dataDic setValue:@"0" forKey:@"code"];
                    [dataDic setValue:@"1" forKey:@"success"];
                    NSMutableArray * videoStrArr = [NSMutableArray array];
                    for (NSDictionary * dd in allResults) {
                        NSDictionary * urlDic = dd[@"data"];
                        [videoStrArr addObject:urlDic[@"url"]];
                    }
                    [dataDic setValue:videoStrArr forKey:@"data"];
                    successBlock(dataDic); // 返回所有结果
                }
            } else {
                [lock unlock];
            }
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [lock lock];
            completedCount++;
            [allResults addObject:@{@"code": @(code), @"msg": message}]; // 存储错误信息
            if (completedCount == totalCount) {
                [lock unlock];
                // 业务逻辑：若只要有一个失败则整体视为失败（可根据需求调整）
                if (failureBlock) {
                    failureBlock(code, message);
                }
            } else {
                [lock unlock];
            }
        }];
    }
     */
}

///获取阿里云配置
+ (void)getAliOSSInfoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@",AliyunOSSHttp];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

///aws文件上传
+ (void)fileAwsUploadWithParameters:(NSDictionary *)parametersDic fileData:(NSData *)fileData mimeType:(NSString *)mimeType Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@?userId=%@",[PGManager shareModel].baseUrl,@"aws/file/upload",[PGManager shareModel].userInfo.userid];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"%ld.%@", (long)timestamp,mimeType];
    [[HMNetworking sharedClient] upload:urlStr parameters:parametersDic fileData:fileData fileName:fileName mimeType:mimeType name:@"file" headers:headerDic progress:^(float progress) {
            
    } success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

///首页推荐列表
+ (void)homeRemandWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/video/list2"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///主播详情
+ (void)anchorDetailWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/detail"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///查询是否关注了对方
+ (void)checkCollectStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/is/follow"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///查询拉黑状态
+ (void)checkBlackenedWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/consumeV2/getIsMutualBeBlackened"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///拉黑
+ (void)blackAddWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/black/list/add"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}
///取消拉黑
+ (void)cancelBlackActionWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/black/list/del"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 举报
+ (void)reportWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"report/saveReport"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///收藏
+ (void)collectAddWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/attention/add"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///取消收藏
+ (void)collectCancelWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/attention/cancel"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///根据id搜索主播
+ (void)searchAnchorWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"app/api/user/search"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取用户信息
+ (void)getUserInfoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/login"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///修改头像
+ (void)updateHeadImgWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/photo/update"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///修改昵称
+ (void)updateNickNameWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/name/update"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///修改年龄
+ (void)updateAgeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/age/update"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///修改身高
+ (void)updateTallWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/height/update"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///修改体重
+ (void)updateWeightWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/weight/update"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///收藏列表
+ (void)myCollectListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/attention/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///我的动态列表
+ (void)myDynamicListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/dynamic/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///女主播动态列表
+ (void)anchorDynamicListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/dynamic/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取绑定的邀请码
+ (void)getBindInviteCodeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/p6/anchor/inviteCode/get"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///补填邀请码
+ (void)writeInviteCodeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/p6/anchor/inviteCode/bind"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///注销账号
+ (void)logOffWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/logoff"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///退出登录
+ (void)logOutWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/logout"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///添加相册
+ (void)addPhotoToAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/album/v2/upload"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///我的相册
+ (void)myAlbumListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/photo/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 删除相册照片
+ (void)deleteAlbumPhotoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/v2/photo/batch/delete"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 动态tab列表
+ (void)dynamicListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/mix/dynamic/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 删除动态
+ (void)deleteDynamicWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/dynamic/info/delete/v2"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 动态发布
+ (void)publishDynamicWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/dynamic/save"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 动态通知，详情
+ (void)dynamicDetailAndNoticeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/dynamic/like/notice"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 查看动态通知
+ (void)checkDynamicNoticeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/dynamic/like/updateState"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 动态点赞
+ (void)dynamicPraiseWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/dynamic/like/ok"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 钻石列表
+ (void)diamondListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/coin/control/get"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 支付列表
+ (void)payListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"app/api/user/getPackageInfo"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 支付判断走原生还是三方
+ (void)payOriginOrThirdWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"app/api/pay/v2/getPayType"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 支付充值
+ (void)payRechargeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"app/api/pay/v2/wakeUpPay"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 获取邀请码及邀请链接
+ (void)getInviteCodeAndLinkWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/get/invitationCode"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 我的邀请列表
+ (void)myInviteListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/inviterDetails"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 我的收益列表
+ (void)myIncomeListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/inviterIntegral"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 赠送礼物
+ (void)sendGiftWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/consumeV2/newGiftDeduction"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///下载
+ (void)downFileWithUrl:(NSString *)url filePath:(NSString *)path Success:(void (^)(id data))successBlock
                failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:@{}];
    [[HMNetworking sharedClient] download:url savePath:path headers:headerDic progress:^(float progress) {
            
    } success:^(NSString * _Nonnull filePath) {
        if (filePath.length>0) {
            successBlock(filePath);
        }else{
            failureBlock(1,Localized(@"下载失败"));
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

///上传语音
+ (void)uploadFileWithAudio:(NSString *)filePath Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    // 1. 初始化总数量和计数器（需线程安全，避免多线程竞争）
    NSInteger totalCount = 1;
    __block NSInteger completedCount = 0;
    __block NSMutableArray *allResults = [NSMutableArray arrayWithCapacity:totalCount]; // 存储所有上传结果
    NSLock *lock = [[NSLock alloc] init]; // 用于计数器同步
    
    NSError * error = nil;
    NSData * voiceData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]
                                             options:NSDataReadingMappedIfSafe // 优化大文件读取性能
                                               error:&error];
    [self fileAwsUploadWithParameters:@{} fileData:voiceData mimeType:@"mp3" Success:^(id  _Nonnull data) {
        [lock lock]; // 加锁，确保计数器操作线程安全
        completedCount++;
        [allResults addObject:data]; // 存储当前上传结果
        // 3. 检查是否所有任务都已完成
        if (completedCount == totalCount) {
            [lock unlock]; // 先解锁再回调（避免回调中耗时操作阻塞锁）
            if (successBlock) {
                NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
                [dataDic setValue:@"0" forKey:@"code"];
                [dataDic setValue:@"1" forKey:@"success"];
                NSMutableArray * imgStrArr = [NSMutableArray array];
                for (NSDictionary * dd in allResults) {
                    NSDictionary * urlDic = dd[@"data"];
                    [imgStrArr addObject:urlDic[@"url"]];
                }
                [dataDic setValue:imgStrArr forKey:@"data"];
                successBlock(dataDic); // 返回所有结果
            }
        } else {
            [lock unlock];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [lock lock];
        completedCount++;
        [allResults addObject:@{@"code": @(code), @"msg": message}]; // 存储错误信息
        if (completedCount == totalCount) {
            [lock unlock];
            // 业务逻辑：若只要有一个失败则整体视为失败（可根据需求调整）
            if (failureBlock) {
                failureBlock(code, message);
            }
        } else {
            [lock unlock];
        }
    }];
}

///用户10s内未接听视频卡或者主动关闭视频的情况下调用
+ (void)userRefuseVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/close/video/card/busy"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 视频通话前预请求
+ (void)videoCheckPreChargingWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"app/api/user/checkPre"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 获取主动拨打视频的资费
+ (void)videoUserPublishWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/video/real/anchor/multiple"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 视频通话扣费(首次接通，到配置首次扣费时间，然后每隔一分钟，到视频结束都要请求)
+ (void)videoChargingWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/consumeV2/newCallDeduction2"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 视频通过结束
+ (void)videoFinishWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/consumeV2/call/finish"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 启动图配置
+ (void)launchScreenConfigWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"app/api/user/getStartPageImage"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 消息发送添加记录
+ (void)messageSendAddRecordWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/message/add"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 女端给男端打视频接通或拒绝
+ (void)callVideoManStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/blackbox/call/status"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///修改在线状态
+ (void)updateUserStateWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"app/api/user/update-state"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///心跳接口
+ (void)heartWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/heart"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///开启忙碌
+ (void)startBusyStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/enable/busy"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///关闭忙碌
+ (void)endBusyStatusWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/close/busy"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///版本更新
+ (void)versionUpdateWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/versionUpdate/getVersionByChannel"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///提现账户列表
+ (void)withdrawListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/withdraw/config/anchor/list"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///删除某个提现账户
+ (void)deleteWithdrawAccountWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/withdraw/config/anchor/remove"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///添加提现账户
+ (void)addWithdrawAccountWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/withdraw/user/createWithdrawAccount"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///提现明细
+ (void)getWithdrawRecordWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"withdrawalMoneys/getBillDetail"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取积分余额
+ (void)jiFenBalanceWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/anchor/anchorBalance"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取当前用户余额
+ (void)userBalanceWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/userBalance"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///一键转入到账户
+ (void)transferToAccountWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/invite/recharge"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}
///提现操作(支付宝)
+ (void)withdrawalActionWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/withdraw/userCashOut"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取女主播通话价格
+ (void)getCallPriceWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/author/coin/config/getAnchorCoinConfig"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取录屏截屏开关
+ (void)getScreenRecordSwitchWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/sys/setting/list"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///普通消息扣费
+ (void)messageChargeWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/consumeV2/newTextChatDeduction"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取声网token
+ (void)getAgroaTokenWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"agora/token/chat/user"];
    NSString * paraStr = [NSString stringWithFormat:@"/%@/token",[PGManager shareModel].userInfo.userid];
    urlStr = [urlStr stringByAppendingString:paraStr];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///首页轮播图
+ (void)homeBannerWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/banner/info"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///女主播预约详情
+ (void)yuYueDetailWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/reservation/user/reserve/info"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}
///查询女主播项目
+ (void)checkAnchorProjectWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/reservation/user/reserve/initiate"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///确认预约
+ (void)sureYuYueWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/reservation/user/reserve/confirm"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///查询未使用预约单
+ (void)checkNoUseYuYueOrderWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/reservation/user/not/use/reserve"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///查询聊天解锁
+ (void)checkChatLockWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/reservation/get/chat/unlock"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}
///解锁聊天
+ (void)updateChatLockWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/reservation/update/chat/unlock"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 个人中心粉丝数和关注数
+ (void)fansAndFollowNumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/get/attention/and/fans/num"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}
///粉丝列表
+ (void)fansListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/fans/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

///关注列表
+ (void)followListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/attention/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

///取消关注
+ (void)cancelAttentionWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/attention/cancel"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

///查询预约记录
+ (void)checkYuyueRecordLsitWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/reservation/user/reserve/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///获取邀请码链接信息
+ (void)getInviteInfoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/user/invitation/info"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] get:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            NSString * msg2 = responseDict[@"message"];
            failureBlock([responseDict[@"code"] integerValue],msg.length>0?msg:msg2);
        }
    } failure:^(NSError *error) {
        failureBlock(50000,@"Network error");
    }];
}

///黑名单列表
+ (void)blackListWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/black/list/userBlackPageList"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}
/// 我的相册
+ (void)myAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/photo/v2/list"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 上传到相册
+ (void)uploadPhotoToAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/album/v2/upload"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 删除相册照片
+ (void)deletePhotoAtAlbumWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/photo/v2/delete"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}
/// 我的视频
+ (void)myVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/video/list"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 上传到视频
+ (void)uploadVideoToVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/video/v2/check/upload"];
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionaryWithDictionary:[self getCommonHeaderOfSubclasses:parametersDic]];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSData * bodyData = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:nil];
    [[HMNetworking sharedClient] postBody:urlStr bodyData:bodyData headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

/// 删除视频
+ (void)deleteVideoAtVideoWithParameters:(NSDictionary *)parametersDic Success:(void (^)(id data))successBlock
                          failure:(void (^)(NSInteger code, NSString* message))failureBlock
{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",[PGManager shareModel].baseUrl,@"api/video/delete"];
    NSDictionary * headerDic = [self getCommonHeaderOfSubclasses:parametersDic];
    [[HMNetworking sharedClient] postForm:urlStr parameters:parametersDic headers:headerDic success:^(id  _Nullable responseObject) {
        NSDictionary *responseDict = responseObject;
        if([responseDict[@"code"] integerValue] == 0){
            successBlock(responseDict);
        }else{
            NSString * msg = responseDict[@"msg"];
            failureBlock([responseDict[@"code"] integerValue],msg);
        }
    } failure:^(NSError * _Nonnull error) {
        failureBlock(50000,@"Network error");
    }];
}

@end
