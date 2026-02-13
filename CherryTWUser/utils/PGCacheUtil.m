//
//  PGCacheUtil.m
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGCacheUtil.h"
#import <SDWebImage/SDImageCache.h>

@implementation PGCacheUtil

/**
 *  清理缓存
 */
+ (void)cleanCache:(cleanCacheBlock)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 图片缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            block();
        }];
        //缓存路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths lastObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"fshyAudio"];
        NSFileManager * manager=[NSFileManager defaultManager];
        if ([manager fileExistsAtPath :path]) {
            [manager removeItemAtPath:path error:nil];
        }
    });
}

/**
 计算缓存
 */
+ (void)computeCache:(void (^)(long size))block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 图片缓存
        long long cacheSize = 0;
        long long imageSize = [[SDImageCache sharedImageCache] totalDiskSize];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths lastObject];
        NSString *path = [docPath stringByAppendingPathComponent:@"fshyAudio"];
        long long audioCacheSize = [self folderSizeAtPath:path];
        cacheSize +=  imageSize / ( kCacheUnitK );
        cacheSize += audioCacheSize;
        
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block(cacheSize);
        });
    });
}

#pragma mark -
+ (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager * manager=[NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 );
}

+ (long long)fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize];
    }
    return 0 ;
}

@end
