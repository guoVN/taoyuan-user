//
//  PGQRCodeTool.h
//  CherryTWUser
//
//  Created by guo on 2024/12/10.
//  Copyright © 2024 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGQRCodeTool : NSObject
/**
 *  根据字符串生成二维码
 *
 *  @param qrString <#qrString description#>
 *
 *  @return <#return value description#>
 */
+(CIImage *)createQRForString:(NSString *)qrString;


/**
 *  生成指定大小的二维码图片
 *
 *  @param qrString 字符串
 *  @param size     图片大小
 *
 *  @return 生成的二维码图片
 */
+(UIImage *)createQRForString:(NSString*)qrString andSize:(CGFloat)size;

/**
 *  将生成的二维码图像CIImage转化成合适大小的UIImage
 *
 *  @param image <#image description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;


/**
 *  将黑色图片转成背景透明带颜色的图片
 *
 *  @param image <#image description#>
 *  @param red   <#red description#>
 *  @param green <#green description#>
 *  @param blue  <#blue description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

+ (UIImage *)imageWithQRImage:(UIImage *)qrImage logo:(UIImage *)logo logoSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
