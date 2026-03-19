//
//  LQWeChatManager.m
//  LiaoQuan
//
//  Created by guo on 2025/12/22.
//

#import "LQWeChatManager.h"

@implementation LQWeChatManager

+ (id)shareInstance {
    static LQWeChatManager *weChatPayInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weChatPayInstance = [[LQWeChatManager alloc] init];
    });
    return weChatPayInstance;
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[LQWeChatManager shareInstance]];
}

+ (void)hangleWechatPayWith:(PayReq *)req {
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            NSLog(@"微信支付成功");
        } else {
             NSLog(@"微信支付异常");
        }
    }];
}

#pragma mark - 微信支付回调

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        /*
         enum  WXErrCode {
         WXSuccess           = 0,    < 成功
         WXErrCodeCommon     = -1,  < 普通错误类型
         WXErrCodeUserCancel = -2,   < 用户点击取消并返回
         WXErrCodeSentFail   = -3,   < 发送失败
         WXErrCodeAuthDeny   = -4,   < 授权失败
         WXErrCodeUnsupport  = -5,   < 微信不支持
         };
         */
        PayResp *response = (PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess: {
                NSLog(@"微信回调支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotificationAlipayOrWechatSuccess"
                                                                    object:nil
                                                                  userInfo:nil];
            break;
            }
            case WXErrCodeCommon: {
                NSLog(@"微信回调支付异常");
                break;
            }
            case WXErrCodeUserCancel: {
                [QMUITips showWithText:@"支付失败"];
                NSLog(@"微信回调用户取消支付");
                break;
            }
            case WXErrCodeSentFail: {
                [QMUITips showWithText:@"支付失败"];
                NSLog(@"微信回调发送支付信息失败");
                break;
            }
            case WXErrCodeAuthDeny: {
                NSLog(@"微信回调授权失败");
                break;
            }
            case WXErrCodeUnsupport: {
                NSLog(@"微信回调微信版本暂不支持");
                break;
            }
            default: {
                break;
            }
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]){
//        SendAuthResp * respss = (SendAuthResp *)resp;
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        [dic setValue:respss.code forKey:@"code"];
//        [dic setValue:[LQUtils getAdId] forKey:@"uuid"];
//        [dic setValue:[LQUtils getMacAddress] forKey:@"mac"];
//        [dic setValue:[LQManager shareModel].userAgent forKey:@"ua"];
//        [dic setValue:@"1" forKey:@"os"];
//        [dic setValue:[LQUtils getAdId] forKey:@"idfa"];
//        [dic setValue:[LQUtils getAdId] forKey:@"imei"];
//        [dic setValue:[LQUtils getAdId] forKey:@"androidid"];
//        [dic setValue:[LQUtils getAdId] forKey:@"oaid"];
//        [HMNetService wxLoginWithParameters:dic Success:^(id  _Nonnull data) {
//            [QMUITips hideAllTips];
//            [LQUtils loginSuccess:data[@"data"]];
//        } failure:^(NSInteger code, NSString * _Nonnull message) {
//            [QMUITips hideAllTips];
//            if (code == 406) {
//                [QMUITips showWithText:@"当前用户被封禁"];
//                [LQUtils forbitUser];
//            }else{
//                [QMUITips showWithText:message];
//            }
//        }];
    }
}


@end
