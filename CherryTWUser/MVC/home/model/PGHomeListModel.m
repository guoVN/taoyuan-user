//
//  PGHomeListModel.m
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGHomeListModel.h"

@implementation PGHomeListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"userInfo" : PGHomeListUserModel.class
    };//前边，是属性数组的名字，后边就是类名
}

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

@implementation PGHomeListUserModel

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
