//
//  UIImage+MP.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "UIImage+MP.h"

@implementation UIImage (MP)

/// 颜色转Image
/// @param color color
/// @param frame frame
+ (UIImage *) yd_imageWithColor:(UIColor *)color frame:(CGRect)frame{
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *) yd_imageWithColor:(UIColor *)color {
    return [self yd_imageWithColor:color frame:CGRectMake(0, 0, 10, 10)];
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//保证图片拉伸不变形
- (UIImage *)yd_resizingImage
{
    CGFloat imageW = self.size.width * 0.5;
    CGFloat imageH = self.size.height * 0.5;
    UIImage *newImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeStretch];
    return newImage;
}

- (UIImage *)yd_originalRenderImage {
    return  [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)applyGaussianBlurWithRadius:(CGFloat)radius {
    // 将 UIImage 转换为 CIImage
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    // 创建高斯模糊滤镜
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:inputImage forKey:kCIInputImageKey];
    [blurFilter setValue:@(radius) forKey:kCIInputRadiusKey]; // 设置模糊半径
    
    // 获取输出图像
    CIImage *outputImage = blurFilter.outputImage;
    
    // 将 CIImage 转换为 UIImage
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage); // 释放 CGImage
    
    return blurredImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
