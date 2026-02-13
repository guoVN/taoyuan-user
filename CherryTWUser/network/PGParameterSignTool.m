//
//  PGParameterSignTool.m
//  CherryTWUser
//
//  Created by guo on 2024/12/10.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGParameterSignTool.h"
#import <CommonCrypto/CommonCrypto.h>

#define signKey @"83cc72177d17fca4"
#define parmeterSignKey @"39f7aa7e5e5749a69991827bfa92b133"

@implementation PGParameterSignTool

/** *加密url

 dataDic要进行签名的字典

 character随机16位数

*/

+(NSString*)encoingWithDic:(NSMutableDictionary*)dataDic andTimeSta:(NSString *)timeSp

{
    /*请求参数按照参数名ASCII码从小到大排序*/
    NSArray *keys = [dataDic allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];

    NSString *returnStr = @"";
    //拼接字符串
    for (int i=0;i<sortedArray.count;i++){
        NSString *category = sortedArray[i];
        if (i==0) {
            returnStr =[NSString stringWithFormat:@"{%@:%@",category,dataDic[category]];
        }else{
            returnStr = [NSString stringWithFormat:@"%@,%@:%@",returnStr,category,dataDic[category]];
        }
    }
    
    if (returnStr.length == 0) {
        returnStr = @"{";
    }
    
    /*拼接上key得到stringSignTemp*/
    returnStr = [NSString stringWithFormat:@"%@}&ts=%@&signKey=%@",returnStr,timeSp,signKey];
    /*md5加密*/
    returnStr = [self bigmd5:returnStr];
    
    return returnStr;
}

+(NSString*)encoingPameterSignWithDic:(NSMutableDictionary*)dataDic andTimeSta:(NSString *)timeSp

{
    /*请求参数按照参数名ASCII码从小到大排序*/
    NSArray *keys = [dataDic allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];

    NSString *returnStr = @"";
    //拼接字符串
    for (int i=0;i<sortedArray.count;i++){
        NSString *category = sortedArray[i];
        NSString * valueStr = [NSString stringWithFormat:@"%@",dataDic[category]];
        if (valueStr.length == 0) {
            continue;
        }
        if (i==0) {
            returnStr =[NSString stringWithFormat:@"%@%@",category,dataDic[category]];
        }else{
            returnStr = [NSString stringWithFormat:@"%@%@%@",returnStr,category,dataDic[category]];
        }
    }
    
    /*拼接上key得到stringSignTemp*/
    returnStr = [NSString stringWithFormat:@"%@%@",parmeterSignKey,returnStr];
    /*md5加密*/
    returnStr = [self md5:returnStr];
    
    return returnStr;
}

//md5 32位加密 （大写）

+(NSString *)bigmd5:(NSString *)str {
    
    const char *input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [digest appendFormat:@"%02X", result[i]];
    }

    return digest;
}

//md5 32位 加密 （小写）

+ (NSString *)md5:(NSString *)str {
    
    const char *input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

/// 生成随机字符串
/// @param length 长度
+ (NSString *)getRandomString:(NSInteger)length
{
    //3.随机字符串kRandomLength位
    static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }

    return randomString;
}


@end
