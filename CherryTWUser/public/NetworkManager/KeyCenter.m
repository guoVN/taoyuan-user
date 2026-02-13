//
//  KeyCenter.m
//  APIExample
//
//  Created by zhaoyongqiang on 2023/7/11.
//

#import "KeyCenter.h"

static NSString * const APPID = @"cbc44b12954d44c3b7525689fa2e5211";
static NSString * const Certificate = nil;

@implementation KeyCenter

+ (nullable NSString *)AppId {
    return APPID;
}

+ (nullable NSString *)Certificate {
    return Certificate;
}

@end
