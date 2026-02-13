//
//  PGParameterSignTool.h
//  CherryTWUser
//
//  Created by guo on 2024/12/10.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGParameterSignTool : NSObject

/** *加密url

 dataDic要进行签名的字典

 character随机16位数

*/

///header签名
+(NSString*)encoingWithDic:(NSMutableDictionary*)dataDic andTimeSta:(NSString *)timeSp;
///参数sign签名
+(NSString*)encoingPameterSignWithDic:(NSMutableDictionary*)dataDic andTimeSta:(NSString *)timeSp;

@end

NS_ASSUME_NONNULL_END
