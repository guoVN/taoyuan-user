//
//  PGLoginModel.m
//  CherryTWUser
//
//  Created by guo on 2024/12/11.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGLoginModel.h"

@implementation PGLoginModel

//+ (NSDictionary *)mj_objectClassInArray{
//    return @{@"pack0" : MPSDeviceDetailPackModel.class
//    };//前边，是属性数组的名字，后边就是类名
//}

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

+ (void)saveInfo:(NSDictionary*)dic
{
    dic = [self removeNilValue:dic];
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:@"userInfoManager"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (PGLoginModel*)readInfo
{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoManager"];
    PGLoginModel * user = [PGLoginModel mj_objectWithKeyValues:dic];
    return user;
}

+ (NSDictionary *)removeNilValue:(NSDictionary *)dic
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dic.allKeys) {
     
        if ([[dic objectForKey:keyStr] isEqual:[NSNull null]]) {
     
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
     
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

@end
