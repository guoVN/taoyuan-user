//
//  PGCacheUtil.h
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCacheUnitK 1024.0

typedef void(^cleanCacheBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface PGCacheUtil : NSObject

/**
 *  清理缓存
 */
+ (void)cleanCache:(cleanCacheBlock)block;

/**
 计算缓存K
 */
+ (void)computeCache:(void (^)(long size))block;

+ (float)folderSizeAtPath:(NSString *)folderPath;

@end

NS_ASSUME_NONNULL_END
