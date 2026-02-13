//
//  PGPayListModel.m
//  CherryTWUser
//
//  Created by guo on 2024/12/26.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPayListModel.h"

@implementation PGPayListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@",key);
}

@end
