//
//  HMYuYueRecordModel.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/26.
//

#import "HMYuYueRecordModel.h"

@implementation HMYuYueRecordModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"records" : HMYuYueRecordListModel.class,
    };//前边，是属性数组的名字，后边就是类名
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",//前边的是你想用的key，后边的是返回的key
             @"NEWReserveDetails" : @"newReserveDetails",
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@",key);
}

@end

@implementation HMYuYueRecordListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"femaleAdditionalConfigList" : HMYuYuefemaleAdditionalModel.class,
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

@implementation HMYuYuefemaleAdditionalModel

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
