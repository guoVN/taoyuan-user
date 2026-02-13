//
//  PGYuYueModel.m
//  CherryTWUser
//
//  Created by guo on 2025/11/17.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGYuYueModel.h"

@implementation PGYuYueModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"morning" : PGYuYueDataModelTimeModel.class,
             @"afternoon" : PGYuYueDataModelTimeModel.class,
             @"night" : PGYuYueDataModelTimeModel.class,
    };//前边，是属性数组的名字，后边就是类名
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",//前边的是你想用的key，后边的是返回的key
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@",key);
}

@end

@implementation PGYuYueDataModelTimeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",//前边的是你想用的key，后边的是返回的key
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@",key);
}

@end
