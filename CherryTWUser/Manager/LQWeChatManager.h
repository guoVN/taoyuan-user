//
//  LQWeChatManager.h
//  LiaoQuan
//
//  Created by guo on 2025/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LQWeChatManager : NSObject

+ (id)shareInstance;

+ (BOOL)handleOpenUrl:(NSURL *)url;

+ (void)hangleWechatPayWith:(PayReq *)req;

@end

NS_ASSUME_NONNULL_END
