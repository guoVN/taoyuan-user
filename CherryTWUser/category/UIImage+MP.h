//
//  UIImage+MP.h
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MP)

/// 颜色转Image
/// @param color color
/// @param frame frame
+ (UIImage *) yd_imageWithColor:(UIColor *)color frame:(CGRect)frame;
+ (UIImage *) yd_imageWithColor:(UIColor *)color;
- (UIImage *)yd_resizingImage;
- (UIImage *)yd_originalRenderImage;
///高斯模糊
- (UIImage *)applyGaussianBlurWithRadius:(CGFloat)radius;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END
