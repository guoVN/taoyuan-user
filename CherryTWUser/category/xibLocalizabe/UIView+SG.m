//
//  UIView+SG.m
//  StepGold
//
//  Created by MrS on 2019/9/18.
//  Copyright © 2019 zyz. All rights reserved.
//

#import "UIView+SG.h"
#import <objc/runtime.h>

static void const *BorderColorKey = &BorderColorKey;
static void const *BorderWidthKey = &BorderWidthKey;
static void const *BorderRadiusKey = &BorderRadiusKey;

@implementation UIView (SG)
+ (instancetype)sg_viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (UIColor *)hBorderColor{
    return objc_getAssociatedObject(self,BorderColorKey);
}
- (void)setHBorderColor:(UIColor *)hBorderColor{
    objc_setAssociatedObject(self, BorderColorKey, hBorderColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.layer.borderColor = hBorderColor.CGColor;
}


- (CGFloat)hBorderWidth{
    return [objc_getAssociatedObject(self,BorderWidthKey) floatValue];
}
- (void)setHBorderWidth:(CGFloat)hBorderWidth{
    objc_setAssociatedObject(self, BorderWidthKey, [NSNumber numberWithFloat:hBorderWidth], OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.layer.borderWidth = hBorderWidth;
}

- (CGFloat)hCornerRadius{
    return [objc_getAssociatedObject(self,BorderRadiusKey) floatValue];
}
- (void)setHCornerRadius:(CGFloat)hCornerRadius{
    objc_setAssociatedObject(self, BorderRadiusKey, [NSNumber numberWithFloat:hCornerRadius], OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.layer.cornerRadius = hCornerRadius;
    self.layer.masksToBounds = hCornerRadius > 0?true:false;
}


- (void)hs_removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (UIImage *)hs_snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
    if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)] ) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}
@end
