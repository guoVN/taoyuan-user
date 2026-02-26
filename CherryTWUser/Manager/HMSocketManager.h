//
//  HMSocketManager.h
//  CherryTWanchor
//
//  Created by guo on 2026/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMSocketManager : NSObject

+ (instancetype)share;

- (void)connect;
- (void)disConnect;
- (void)sendMsg:(NSString *)msg;
- (void)ping;

@end

NS_ASSUME_NONNULL_END
