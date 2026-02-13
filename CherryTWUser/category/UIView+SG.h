//
//  UIView+SG.h
//  StepGold
//
//  Created by MrS on 2019/9/18.
//  Copyright © 2019 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SG)
+ (instancetype)sg_viewFromXib;

/** 自定义属性关联xib，和storyboard(只支持int,CGFloat,double,String,Bool,CGPoint,CGSize,CGRect,UIColor,UIImage)
 */
@property (nonatomic) IBInspectable CGFloat hCornerRadius;
@property (nonatomic) IBInspectable CGFloat hBorderWidth;
@property (nonatomic) IBInspectable UIColor * hBorderColor;

/// 移除所有子视图
- (void)hs_removeAllSubviews;
/// 对view进行截屏
- (UIImage *)hs_snapshot;
@end

NS_ASSUME_NONNULL_END
