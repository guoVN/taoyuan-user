//
//  HMPlayTypeProjectModel.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/30.
//

#import "HMPlayTypeProjectModel.h"

@implementation HMPlayTypeProjectModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"femaleAdditionalConfigList" : HMPlayTypeProjectListModel.class,
             @"selectorConfigs" : HMPlayTypeProjectListModel.class,
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

@implementation HMPlayTypeProjectListModel

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
