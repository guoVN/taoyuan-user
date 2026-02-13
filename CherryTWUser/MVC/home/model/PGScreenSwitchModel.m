//
//  PGScreenSwitchModel.m
//  CherryTWUser
//
//  Created by guo on 2025/2/7.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGScreenSwitchModel.h"

@implementation PGScreenSwitchModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",//前边的是你想用的key，后边的是返回的key
             @"DESC" : @"description"
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@",key);
}

@end
