//
//  PGVersionModel.h
//  CherryTWUser
//
//  Created by guo on 2025/1/17.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGVersionModel : NSObject

@property (nonatomic, copy) NSString * appUrl;
@property (nonatomic, copy) NSString * channel;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString * appName;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * miniVersion;
@property (nonatomic, copy) NSString * latestVersion;
@property (nonatomic, copy) NSString * createTime;

@end

NS_ASSUME_NONNULL_END
