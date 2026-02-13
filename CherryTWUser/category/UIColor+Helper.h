//
//  UIColor+Helper.h
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Helper)

/**
 获取图片的主色调（出现最多的颜色）

 @param image 原图
 @param scale 精准度（0~1）
 @return 主色调颜色
 */
+ (UIColor *)colorWithMostImage:(UIImage *)image scale:(CGFloat)scale;

+ (UIColor *)colorWithHex:(NSString *)hexValue alpha:(CGFloat)alpha;

+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

+ (NSString *)hexFromUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
