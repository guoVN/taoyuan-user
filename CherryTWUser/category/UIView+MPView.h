//
//  UIView+MPView.h
//  CherryTWUser
//
//  Created by guo on 2024/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 边框类型(位移枚举)
typedef NS_ENUM(NSInteger, UIBorderSideType) {
    UIBorderSideTypeAll    = 0,
    UIBorderSideTypeTop    = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft   = 1 << 2,
    UIBorderSideTypeRight  = 1 << 3,
};

typedef NS_OPTIONS(NSUInteger, BNShadowSide) {
    BNShadowSideNone   = 0,
    BNShadowSideTop    = 1 << 0,
    BNShadowSideLeft   = 1 << 1,
    BNShadowSideBottom = 1 << 2,
    BNShadowSideRight  = 1 << 3,
    BNShadowSideAll    = BNShadowSideTop | BNShadowSideLeft | BNShadowSideBottom | BNShadowSideRight
};

@interface UIView (MPView)

+ (instancetype)yd_viewFromXib;

#pragma mark - 渐变
- (CAGradientLayer *)yd_gradientLayer;
- (void)yd_setVeticalGradualFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor;
- (void)yd_setHorizentalGradualFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor;
- (void)yd_setVeticalGradualWithColors:(NSArray<UIColor*>*)colors locations:(NSArray<NSNumber*>*)locations;
- (void)yd_setHorizentalGradualWithColors:(NSArray<UIColor*>*)colors locations:(NSArray<NSNumber*>*)locations;

// 高斯模糊（毛玻璃）
- (void)addBlurEffect;
- (void)addBlurEffect:(UIBlurEffectStyle)style withAlpha:(CGFloat)alpha;
- (void)addBlurEffectWithStyle:(UIBlurEffectStyle)style;

// 阴影
- (void)addShadowByStlye1;
- (void)addShadowWithColor:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;

/**
 圆角
 使用自动布局，需要在layoutsubviews 中使用
 @param radius 圆角尺寸
 @param corner 圆角位置
 */
- (void)acs_radiusWithRadius:(CGFloat)radius corner:(UIRectCorner)corner;

/**
 设置view指定位置的边框

 @param originalView   原view
 @param color          边框颜色
 @param borderWidth    边框宽度
 @param borderType     边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
 @return  view
 */
- (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(UIBorderSideType)borderType;

/// 使用位枚举指定圆角位置
/// 通过在各个边画矩形来实现shadowpath，真正实现指那儿打那儿
/// @param shadowColor 阴影颜色
/// @param shadowOpacity 阴影透明度
/// @param shadowRadius 阴影半径
/// @param shadowSide 阴影位置
-(void)addShdowColor:(UIColor *)shadowColor
       shadowOpacity:(CGFloat)shadowOpacity
        shadowRadius:(CGFloat)shadowRadius
          shadowSide:(BNShadowSide)shadowSide;

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
        roundedCorners:(UIRectCorner)roundedCorners;

///创建水波纹
- (void)startRipple:(CGFloat)radius fromValue:(id)fromV toValue:(id)toV;

@end

NS_ASSUME_NONNULL_END
