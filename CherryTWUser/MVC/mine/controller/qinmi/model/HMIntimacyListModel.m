//
//  HMIntimacyListModel.m
//  CherryTWanchor
//
//  Created by guo on 2025/9/16.
//

#import "HMIntimacyListModel.h"

@implementation HMIntimacyListModel

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
