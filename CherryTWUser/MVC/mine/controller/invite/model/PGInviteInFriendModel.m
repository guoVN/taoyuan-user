//
//  PGInviteInFriendModel.m
//  CherryTWUser
//
//  Created by guo on 2024/12/26.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteInFriendModel.h"

@implementation PGInviteInFriendModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : PGInviteInFriendModelListModel.class
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

@implementation PGInviteInFriendModelListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"records" : PGInviteInFriendModelListRecordsModel.class
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

@implementation PGInviteInFriendModelListRecordsModel

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
