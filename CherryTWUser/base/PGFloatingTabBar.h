//
//  PGFloatingTabBar.h
//  CherryTWUser
//
//  Created by guo on 2025/10/22.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TabBarItemClickBlock)(NSInteger index);

@interface PGFloatingTabBar : UIView

@property (nonatomic, strong) UIColor *backgroundColor;  // 背景色
@property (nonatomic, strong) UIColor *selectedTintColor; // 选中图标颜色
@property (nonatomic, strong) UIColor *normalTintColor;   // 未选中图标颜色
@property (nonatomic, assign) CGFloat cornerRadius;       // 圆角半径
@property (nonatomic, copy) TabBarItemClickBlock itemClickBlock; // 点击回调

@property (nonatomic, strong) UIColor *badgeBackgroundColor; // 角标背景色（默认红色）
@property (nonatomic, strong) UIColor *badgeTextColor;       // 角标文字色（默认白色）
@property (nonatomic, strong) UIFont *badgeFont;             // 角标字体（默认11号粗体）
@property (nonatomic, assign) CGFloat badgeMinWidth;         // 角标最小宽度（默认20pt，确保单个数字时是圆形）

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                        icons:(NSArray<UIImage *> *)icons
                    selectIcons:(NSArray<UIImage *> *)selectIcons;

// 更新选中项
- (void)selectItemAtIndex:(NSInteger)index;

/// 设置角标数值（0 或 nil 隐藏角标）
- (void)setBadgeValue:(nullable NSString *)value forIndex:(NSInteger)index;
/// 隐藏角标
- (void)hideBadgeForIndex:(NSInteger)index;
/// 显示角标（无数值，仅显示红点）
- (void)showDotBadgeForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
