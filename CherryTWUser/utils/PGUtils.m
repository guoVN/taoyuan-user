//
//  PGUtils.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGUtils.h"
#import <AdSupport/ASIdentifierManager.h>
#import <WebKit/WebKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "PGContainerVC.h"
#import "AppDelegate.h"
#import "PGNavigationViewController.h"
#import "PGCustomViewController.h"
#import "PGCallRechargeView.h"
#import "PGDiamondsListViewController.h"
#import "PGCustomAlertView.h"
#import "PGVersionModel.h"

@implementation PGUtils

+(NSMutableAttributedString *)setColor:(UIColor *)color
          allString:(NSString *)allString
           font:(UIFont *)font
           text:(NSString *)text
{
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:allString];
    //找出特定字符在整个字符串中的位置
    NSRange redRange = NSMakeRange([[contentStr string] rangeOfString:text].location, [[contentStr string] rangeOfString:text].length);
    //修改特定字符的颜色
    [contentStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    //修改特定字符的字体大小
    [contentStr addAttribute:NSFontAttributeName value:font range:redRange];
    return contentStr;
}

//时间戳转时间
+ (NSString *)ConvertsStringToTime:(NSString *)timeStr
{
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}
///时间转时间戳
+ (NSInteger)ConvertsTimeStrToTimeStamp:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval timeStamp = [deadline timeIntervalSince1970];
    timeDifference = timeStamp-0;
    return timeDifference;
}

//时间戳转换为几分钟前
+ (NSString *)timeBeforeInfoWithString:(NSTimeInterval)timeIntrval{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timeIntrval; //时间差
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:timeIntrval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:date];
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
//    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%@",timeString];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%@",timeString];
    }else if (day >= 7){
        return [NSString stringWithFormat:@"%@",timeString];
    }else if(day > 0 && day < 7){
        return [NSString stringWithFormat:@"%d天前",day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时前",hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟前",minute];
    }else{
        return [NSString stringWithFormat:@"刚刚"];
    }
}
//时间戳转时间（mm-dd HH:mm）
+ (NSString *)ConvertsStringToTimeYDHM:(NSString *)timeStr
{
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//获取当前导航
+(UIViewController *)getCurrentVC
{
   return  [UIViewController currentViewController];
}

// 将字典或者数组转化为JSON串
+ (NSString *)objectToJson:(id)obj
{
    if (obj == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
 
    if ([jsonData length] && error == nil) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+ (id)jsonToObject:(NSString *)json
{
    // string转data
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    // json解析
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return obj;
}

#pragma mark===压缩图片
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    __block NSData *canCompressMinData = [NSData data];//当无法压缩到指定大小时，用于存储当前能够压缩到的最小值数据。
    [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize resultBlock:^(NSData *finallData, NSData *tempData) {
        finallImageData = finallData;
        canCompressMinData = tempData;
    }];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize resultBlock:^(NSData *finallData, NSData *tempData) {
            finallImageData = finallData;
            canCompressMinData = tempData;
        }];
    }
    //如果分辨率已经无法再降低，则直接使用能够压缩的那个最小值即可
    if (finallImageData.length==0) {
        finallImageData = canCompressMinData;
    }
    return finallImageData;
}
#pragma mark 二分法
///二分法，block回调中finallData长度不为零表示最终压缩到了指定的大小，如果为零则表示压缩不到指定大小。tempData表示当前能够压缩到的最小值。
+ (void)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize resultBlock:(void(^)(NSData *finallData, NSData *tempData))block {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1000;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        //        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    NSData *d = [NSData data];
    if (tempData.length==0) {
        d = finallImageData;
    }
    if (block) {
        block(tempData, d);
    }
//    return tempData;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
///调整图片分辨率/尺寸（等比例缩放）
+ (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    //    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)showPickImageCountLimitAlertView:(NSInteger)photoCount {
    NSString *message = [NSString stringWithFormat:@"最多只能选%ld张照片",photoCount];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:defaultAction];
    [[PGUtils getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

///保存指定视图生成图片保存至相册
+ (void)saveImgWithView:(UIView *)imgView
{
    UIImage * img = [[UIImage alloc] init];
    imgView.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, 0), 1, 1);
    img = [self captureImageFromView:imgView];
    UIImageWriteToSavedPhotosAlbum([self pngFromImage:img], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
//防止白边
+ (UIImage *)pngFromImage:(UIImage *)image {
    // UIImage对象保存为PNG格式的函数（函数会返回一个包含图片PNG数据的NSData对象）
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        UIImage *imagePng = [UIImage imageWithData:imageData];
        return imagePng;
    }
    return nil;
}
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        [QMUITips showWithText:@"保存成功"];
    }else{
        [QMUITips showWithText:@"保存失败"];
    }
}
///截图功能
+ (UIImage *)captureImageFromView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO, 0);
    
    [[UIColor clearColor] setFill];
    
    //[[UIBezierPath bezierPathWithRect:view.bounds] fill];
    [[UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:5] addClip];

    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}
///获取设备唯一标识
+(NSString *)getAdId
{
    NSString * adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId.length > 0 ? adId : @"";
}

///从数组中随机取n个元素
+ (NSArray *)randomArray:(NSArray *)dataArray byLength:(NSInteger)length
{
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];

    while ([randomSet count] < length) {
        int r = arc4random() % [dataArray count];
        [randomSet addObject:[dataArray objectAtIndex:r]];
    }

    NSArray *randomArray = [randomSet allObjects];
    return  randomArray;
}
///获取ua
+(void)getUserAgent{
    WKWebView * webView = [[WKWebView alloc] init];
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString * userAgent = result;
        [PGManager shareModel].userAgent = userAgent;
    }];
}
///获取mac地址
+(NSString *)getMacAddress
{
    id info = nil;
    #if TARGET_OS_IOS
        NSArray* ifs = CFBridgingRelease(CNCopySupportedInterfaces());
        for (NSString* ifname in ifs) {
            info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)ifname);
            if (info && [info count]) {
                break;
            }
        }
    #else

    #endif
    NSDictionary* dic = (NSDictionary*)info;
    NSString* bssid = [dic objectForKey:@"BSSID"];
    return bssid ? bssid : @"";
}
///获取当前时间戳
+(NSString *)getCurrentTimeStamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeStamp=[dat timeIntervalSince1970] * 1000;
    NSString *timeStampString = [NSString stringWithFormat:@"%ld",(long)timeStamp];
    return timeStampString;
}
///登录成功后的操作
+(void)loginSuccess:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginSuccess"];
    [[NSUserDefaults standardUserDefaults] setValue:dic[@"loginToken"] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [PGLoginModel saveInfo:dic];
    PGLoginModel * loginModel = [PGLoginModel mj_objectWithKeyValues:dic];
    [self loginIM:loginModel];
    [PGManager shareModel].userInfo = loginModel;
    PGContainerVC * tabbar = [[PGContainerVC alloc] init];
    PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:tabbar];
    [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate reRequestData];
}
///登录im
+ (void)loginIM:(PGLoginModel *)model
{
    [PGAPIService getAgroaTokenWithParameters:@{} Success:^(id  _Nonnull data) {
        NSString * agroaToken = data[@"data"];
        [[AgoraChatClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"%@",model.userid]
                                             token:agroaToken
                                           completion:^(NSString *aUsername, AgoraChatError *aError) {
            // 异步方法
            [AgoraChatClient.sharedClient.pushManager updatePushDisplayStyle:AgoraChatPushDisplayStyleMessageSummary completion:^(AgoraChatError * aError)
            {
                if (aError) {
                    NSLog(@"update display style error --- %@", aError.errorDescription);
                }
            }];
        }];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
///退出登录
+ (void)loginOut
{
    [PGManager shareModel].userInfo = [PGLoginModel readInfo];
    if ([[PGManager shareModel].userInfo.userid integerValue] == 0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loginSuccess"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [PGLoginModel saveInfo:@{}];
    [AgoraChatClient.sharedClient logout:YES completion:^(AgoraChatError * _Nullable aError) {
        
    }];
    PGCustomViewController * vc = [[PGCustomViewController alloc] init];
    PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = 0;
    [[PGUtils getCurrentVC] presentViewController:nav animated:YES completion:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
///更新用户信息
+ (void)getUserInfo
{
    WeakSelf(self)
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:app_Version forKey:@"aversion"];
    [PGAPIService getUserInfoWithParameters:dic Success:^(id  _Nonnull data) {
        NSDictionary * dic = data[@"data"];
        [weakself updateUserInfo:dic];
        [PGManager shareModel].isUpdateUserInfo = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FirstEnterState" object:nil userInfo:nil];
        if (![[PGManager shareModel].searviceLinkStr containsString:@"&userid"]) {
            NSString * pin = [NSString stringWithFormat:@"&userid=%@&name=%@",[PGManager shareModel].userInfo.userid,[PGManager shareModel].userInfo.nickName];
            NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
            NSString *encodedURLString = [pin stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
            [PGManager shareModel].searviceLinkStr = [[PGManager shareModel].searviceLinkStr stringByAppendingString:encodedURLString];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        if (code == 1 || code == 2 || [message containsString:@"用户不存在"]) {
            [PGUtils loginOut];
        }
    }];
}
+(void)updateUserInfo:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginSuccess"];
    [[NSUserDefaults standardUserDefaults] setValue:dic[@"loginToken"] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [PGLoginModel saveInfo:dic];
    PGLoginModel * loginModel = [PGLoginModel mj_objectWithKeyValues:dic];
    [PGManager shareModel].userInfo = loginModel;
    [PGManager shareModel].selfCoin = [PGManager shareModel].userInfo.coin;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserInfo" object:nil userInfo:nil];
}

///打乱数组顺序
+ (NSArray *)getRadomArr:(NSArray *)arr
{
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    return arr;
}
///根据内容判断文件类型
+ (NSString * )getFileFormat:(NSString *)content
{
    if ([content containsString:@"http"]) {
        NSURL * url = [NSURL URLWithString:content];
        NSString * extension = url.pathExtension;
        if ([extension containsString:@"jpg"] || [extension containsString:@"png"] || [extension containsString:@"webp"] || [extension containsString:@"jpeg"]) {
            return @"图片";
        }else if ([extension containsString:@"mp4"] || [extension containsString:@"avi"] || [extension containsString:@"mov"] || [extension containsString:@"rmvb"] || [extension containsString:@"3gp"]){
            return @"视频";
        }else if ([extension containsString:@"mp3"] || [extension containsString:@"wav"] || [extension containsString:@"wma"] || [extension containsString:@"ogg"] || [extension containsString:@"ape"] || [extension containsString:@"m4a"]){
            return @"语音";
        }else{
            return @"文字";
        }
    }
    return @"文字";
}
///去充值
+ (void)goRecharge
{
    PGCallRechargeView * rechargeView = [[PGCallRechargeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    PGDiamondsListViewController * vc = [[PGDiamondsListViewController alloc] init];
    vc.isCallRecharge = YES;
    PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
    nav.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-200);
    [nav.view acs_radiusWithRadius:18 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    [rechargeView.backView addSubview:nav.view];
    [rechargeView.backView bringSubviewToFront:rechargeView.closeBtn];
    rechargeView.refreshCoinBlock = ^{
        [PGUtils getUserInfo];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:rechargeView];
}
+ (void)goRechargeAlert
{
    PGCustomAlertView * alertView = [[PGCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertView.type = 5;
    [alertView.tipsImg setImage:MPImage(@"ku")];
    alertView.titleLabel.text = @"温馨提示";
    alertView.contentLabel.text = @"您的钻石不够啦，请充值钻石哦～";
    [alertView.sureBtn setTitle:@"去充值" forState:UIControlStateNormal];
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}

///获取视频封面，本地视频，网络视频都可以用
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:nil];
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];

    return thumbImg;
}
///版本更新
+ (void)versionUpdate
{
    WeakSelf(self)
    [PGAPIService versionUpdateWithParameters:@{@"channel":Channel_Name} Success:^(id  _Nonnull data) {
        PGVersionModel * model = [PGVersionModel mj_objectWithKeyValues:data[@"data"]];
        [weakself updateVersionAlert:model];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
+ (void)updateVersionAlert:(PGVersionModel *)model
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    QMUIAlertController * alertController = [[QMUIAlertController alloc] initWithTitle:@"检测到新版本，是否更新" message:[NSString stringWithFormat:@"\n%@",model.content] preferredStyle:QMUIAlertControllerStyleAlert];
    ///强更
    if ([model.miniVersion integerValue] > [app_Version integerValue]) {
        [alertController addAction:[QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            NSURL *alipayURL = [NSURL URLWithString:model.appUrl];
            [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                
            }];
            [alertController showWithAnimated:YES];
        }]];
        NSMutableDictionary *sureAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertButtonAttributes];
        sureAttributes[NSForegroundColorAttributeName] = HEX(#333333);
        alertController.alertButtonAttributes = sureAttributes;
        [alertController showWithAnimated:YES];
        return;
    }
    //不强更
    if ([model.latestVersion integerValue] > [app_Version integerValue]) {
        [alertController addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
            NSURL *alipayURL = [NSURL URLWithString:model.appUrl];
            [[UIApplication sharedApplication] openURL:alipayURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                
            }];
        }]];
        NSMutableDictionary *sureAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertButtonAttributes];
        sureAttributes[NSForegroundColorAttributeName] = HEX(#333333);
        alertController.alertButtonAttributes = sureAttributes;
        [alertController showWithAnimated:YES];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionLatest" object:nil userInfo:nil];
}
///去掉多余的零
+ (NSString *)removeExcessZeros:(NSString *)value {
    if ([value rangeOfString:@"."].length != 0) {
        [value rangeOfString:@"0" options:1];
        while ([[value substringWithRange:NSMakeRange(value.length - 1, 1)] isEqualToString:@"0"]) {
            value = [value substringWithRange:NSMakeRange(0, value.length - 1)];
        }
        // 考虑到如果小数点后面都为0的情况.也需要将小数点移除
        if ([[value substringWithRange:NSMakeRange(value.length - 1, 1)] isEqualToString:@"."]) {
            value = [value substringWithRange:NSMakeRange(0, value.length - 1)];
        }
    }
    return value;
}
///四舍五入保留2位小数
+ (NSString *)FloatKeepOneBits:(float)floatnum {
    // 保留1位小数
    NSString * tempfloat = [NSString stringWithFormat:@"%0.2f",roundf(floatnum * 100)/100];
    // 末尾清零
    tempfloat = [self removeExcessZeros:tempfloat];
    return tempfloat;
}

///去掉多余的0
+ (NSString *)formatNumber:(double)number {
    // 1. 判断是否为整数（小数部分全为0）
    if (number == floor(number)) {
        // 整数：直接转换为不带小数的字符串（如123.000 → "123"）
        return [NSString stringWithFormat:@"%.0f", number];
    }
    
    // 2. 非整数：去掉末尾多余的0
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle; // 十进制格式
    formatter.maximumFractionDigits = 10; // 最大保留10位小数（可根据需求调整）
    formatter.minimumFractionDigits = 0; // 最小保留0位小数
    formatter.usesSignificantDigits = NO; // 不使用有效数字模式
    
    // 3. 转换并返回结果
    return [formatter stringFromNumber:@(number)] ?: [NSString stringWithFormat:@"%g", number];
}

@end
