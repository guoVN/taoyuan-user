//
//  UIView+MPView.m
//  CherryTWUser
//
//  Created by guo on 2024/4/9.
//

#import "UIView+MPView.h"
#import <objc/runtime.h>

@implementation UIView (MPView)

+ (instancetype)yd_viewFromXib {
    return [[[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
}

#pragma mark - 渐变
- (void)yd_setVeticalGradualFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor {
    
    CAGradientLayer *gradientLayer = [self yd_gradientLayer];
    if (gradientLayer == nil) {
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
        
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1); // 垂直方向
        
        //  设置颜色变化点，取值范围 0.0~1.0
        gradientLayer.locations = @[@0,@1];
        [self yd_setGradientLayer:gradientLayer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }else {
       gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    }
    
    gradientLayer.frame = self.bounds;
}

- (void)yd_setHorizentalGradualFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor {
    
    CAGradientLayer *gradientLayer = [self yd_gradientLayer];
    if (gradientLayer == nil) {
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
        
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        
        //  设置颜色变化点，取值范围 0.0~1.0
        gradientLayer.locations = @[@0,@1];
        [self yd_setGradientLayer:gradientLayer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
    } else {
       gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    }
    
    gradientLayer.frame = self.bounds;
}

- (void)yd_setVeticalGradualWithColors:(NSArray<UIColor*>*)colors locations:(NSArray<NSNumber*>*)locations {
    
    CAGradientLayer *gradientLayer = [self yd_gradientLayer];
    if (gradientLayer == nil) {
        gradientLayer = [CAGradientLayer layer];
        NSMutableArray *cgColors = @[].mutableCopy;
        for (int i=0; i<colors.count; i++) {
            [cgColors addObject:(__bridge id)colors[i].CGColor];
        }
        gradientLayer.colors = cgColors;
        
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1); // 垂直方向
        
        //  设置颜色变化点，取值范围 0.0~1.0
        gradientLayer.locations =locations;
        [self yd_setGradientLayer:gradientLayer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
    
    gradientLayer.frame = self.bounds;
}

- (void)yd_setHorizentalGradualWithColors:(NSArray<UIColor*>*)colors locations:(NSArray<NSNumber*>*)locations {
    
    CAGradientLayer *gradientLayer = [self yd_gradientLayer];
    if (gradientLayer == nil) {
        gradientLayer = [CAGradientLayer layer];
        NSMutableArray *cgColors = @[].mutableCopy;
        for (int i=0; i<colors.count; i++) {
            [cgColors addObject:(__bridge id)colors[i].CGColor];
        }
        gradientLayer.colors = cgColors;
        
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(0, 0); // 垂直方向
        
        //  设置颜色变化点，取值范围 0.0~1.0
        gradientLayer.locations =locations;
        [self yd_setGradientLayer:gradientLayer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
    
    gradientLayer.frame = self.bounds;
}


static const char YDGradientLayerKey = '\0';
- (void)yd_setGradientLayer:(CAGradientLayer *)layer {
    if (layer != [self yd_gradientLayer]) {
        objc_setAssociatedObject(self, &YDGradientLayerKey, layer, OBJC_ASSOCIATION_RETAIN);
    }
}

- (CAGradientLayer *)yd_gradientLayer {
    return objc_getAssociatedObject(self, &YDGradientLayerKey);
}


- (void)addBlurEffect {
    [self addBlurEffectWithStyle:UIBlurEffectStyleLight];
}
- (void)addBlurEffect:(UIBlurEffectStyle)style withAlpha:(CGFloat)alpha;
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.alpha = alpha;
    [self insertSubview:visualView atIndex:0];
    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)addBlurEffectWithStyle:(UIBlurEffectStyle)style {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    [self insertSubview:visualView atIndex:0];
    [visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)addShadowByStlye1 {
    [self addShadowWithColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.13] offset:CGSizeMake(0,2) radius:2 opacity:1];
}

- (void)addShadowWithColor:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

/**
 圆角
 使用自动布局，需要在layoutsubviews 中使用
 @param radius 圆角尺寸
 @param corner 圆角位置
 */
- (void)acs_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner {
    if (@available(iOS 11.0, *)) {
        self.layer.cornerRadius = radius;
        self.layer.maskedCorners = (CACornerMask)corner;
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}

/**
 设置view指定位置的边框

 @param originalView   原view
 @param color          边框颜色
 @param borderWidth    边框宽度
 @param borderType     边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
 @return  view
 */
- (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType {
    
    if (borderType == UIBorderSideTypeAll) {
        originalView.layer.borderWidth = borderWidth;
        originalView.layer.borderColor = color.CGColor;
        return originalView;
    }
    
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.0f, 0.0f)];
    }
    
    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [bezierPath moveToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }
    
    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
    }
    
    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }
  
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    
    [originalView.layer addSublayer:shapeLayer];
    
    return originalView;
}

-(void)addShdowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(BNShadowSide)shadowSide{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = shadowOpacity;
    
    // 默认值 0 -3
    // 使用默认值即可，这个各个边都要设置阴影的，自己调反而效果不是很好。
    //    self.layer.shadowOffset = CGSizeMake(0, -3);
    
    CGRect bounds = self.layer.bounds;
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat maxY = CGRectGetMaxY(bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (shadowSide & BNShadowSideTop) {
        // 上边
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(0, -shadowRadius)];
        [path addLineToPoint:CGPointMake(maxX, -shadowRadius)];
        [path addLineToPoint:CGPointMake(maxX, 0)];
    }
    
    if (shadowSide & BNShadowSideRight) {
        // 右边
        [path moveToPoint:CGPointMake(maxX, 0)];
        [path addLineToPoint:CGPointMake(maxX,maxY)];
        [path addLineToPoint:CGPointMake(maxX + shadowRadius, maxY)];
        [path addLineToPoint:CGPointMake(maxX + shadowRadius, 0)];
    }
    
    if (shadowSide & BNShadowSideBottom) {
        // 下边
        [path moveToPoint:CGPointMake(0, maxY)];
        [path addLineToPoint:CGPointMake(maxX,maxY)];
        [path addLineToPoint:CGPointMake(maxX, maxY + shadowRadius)];
        [path addLineToPoint:CGPointMake(0, maxY + shadowRadius)];
    }
    
    if (shadowSide & BNShadowSideLeft) {
        // 左边
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(-shadowRadius,0)];
        [path addLineToPoint:CGPointMake(-shadowRadius, maxY)];
        [path addLineToPoint:CGPointMake(0, maxY)];
    }
    
    self.layer.shadowPath = path.CGPath;
}
/// @param shadowColor 阴影颜色
/// @param shadowOpacity 阴影透明度（0~1）
/// @param shadowRadius 阴影柔和度
/// @param shadowSide 指定阴影边（支持多边组合）
/// @param roundedCorners 指定圆角位置
/// @param cornerRadius 圆角半径
- (void)addShadowColor:(UIColor *)shadowColor
         shadowOpacity:(CGFloat)shadowOpacity
          shadowRadius:(CGFloat)shadowRadius
            shadowSide:(BNShadowSide)shadowSide
          cornerRadius:(CGFloat)cornerRadius
       roundedCorners:(UIRectCorner)roundedCorners {
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowOffset = CGSizeZero; // 重置为0，让阴影均匀分布
    
    // 设置圆角
    if (cornerRadius > 0) {
        self.layer.cornerRadius = cornerRadius;
        
        if (@available(iOS 11.0, *)) {
            self.layer.maskedCorners = (CACornerMask)roundedCorners;
        } else {
            // iOS 11 之前的备用方案 - 使用贝塞尔路径创建圆角
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:roundedCorners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
            self.layer.mask = maskLayer;
        }
    }
    
    // 创建阴影路径 - 基于圆角矩形的路径
    CGRect shadowRect = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:shadowRect
                                               byRoundingCorners:roundedCorners
                                                     cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    // 根据阴影边调整路径
    if (shadowSide != BNShadowSideAll) {
        // 如果不是所有边都有阴影，需要创建自定义路径
        path = [UIBezierPath bezierPath];
        
        CGFloat shadowSpread = shadowRadius; // 阴影扩散距离
        
        CGRect expandedRect = shadowRect;
        
        // 根据阴影边扩展矩形
        if (shadowSide & BNShadowSideTop) {
            expandedRect.origin.y -= shadowSpread;
            expandedRect.size.height += shadowSpread;
        }
        if (shadowSide & BNShadowSideBottom) {
            expandedRect.size.height += shadowSpread;
        }
        if (shadowSide & BNShadowSideLeft) {
            expandedRect.origin.x -= shadowSpread;
            expandedRect.size.width += shadowSpread;
        }
        if (shadowSide & BNShadowSideRight) {
            expandedRect.size.width += shadowSpread;
        }
        
        // 创建带圆角的扩展路径
        path = [UIBezierPath bezierPathWithRoundedRect:expandedRect
                                     byRoundingCorners:roundedCorners
                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    }
    
    self.layer.shadowPath = path.CGPath;
}

///创建水波纹
- (void)startRipple:(CGFloat)radius fromValue:(id)fromV toValue:(id)toV
{
    CALayer * rippleLayer = [[CALayer alloc] init];
    rippleLayer.backgroundColor = HEXAlpha(#FFFFFF, 0.08).CGColor;
    rippleLayer.opacity = 0.0;
    rippleLayer.cornerRadius = radius;
    rippleLayer.frame = self.bounds;
    [self.layer addSublayer:rippleLayer];
    //执行动画
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = fromV;
    animation.toValue = toV;
    animation.duration = 1.0;
    animation.repeatCount = 100000;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [rippleLayer addAnimation:animation forKey:@"rippleAnimation"];
    //水波纹逐渐消失
    CABasicAnimation * fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = fromV;
    fadeAnimation.toValue = toV;
    fadeAnimation.duration = 1.0;
    fadeAnimation.repeatCount = 100000;
    fadeAnimation.fillMode = kCAFillModeForwards;
    fadeAnimation.removedOnCompletion = NO;
    [rippleLayer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

@end
