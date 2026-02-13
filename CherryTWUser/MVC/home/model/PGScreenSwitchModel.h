//
//  PGScreenSwitchModel.h
//  CherryTWUser
//
//  Created by guo on 2025/2/7.
//  Copyright © 2025 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGScreenSwitchModel : NSObject

@property (nonatomic, copy) NSString * values;
@property (nonatomic, copy) NSString * channel;
@property (nonatomic, copy) NSString * channelType;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString * keys;
@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * DESC;

@end

NS_ASSUME_NONNULL_END
