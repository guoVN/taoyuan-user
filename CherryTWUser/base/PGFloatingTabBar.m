//
//  PGFloatingTabBar.m
//  CherryTWUser
//
//  Created by guo on 2025/10/22.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGFloatingTabBar.h"

@interface PGFloatingTabBar ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer; // 背景形状层
@property (nonatomic, strong) NSMutableArray<UIButton *> *itemButtons; // 按钮数组
@property (nonatomic, strong) NSArray<UIImage *> *icons;     // 未选中图标
@property (nonatomic, strong) NSArray<UIImage *> *selectIcons; // 选中图标
@property (nonatomic, assign) NSInteger currentIndex;        // 当前选中索引

//角标数组（与 itemButtons 一一对应）
@property (nonatomic, strong) NSMutableArray<UILabel *> *badgeLabels;


@end

@implementation PGFloatingTabBar

- (instancetype)initWithFrame:(CGRect)frame
                        icons:(NSArray<UIImage *> *)icons
                    selectIcons:(NSArray<UIImage *> *)selectIcons {
    self = [super initWithFrame:frame];
    if (self) {
        _icons = [icons copy];
        _selectIcons = [selectIcons copy];
        _cornerRadius = frame.size.height / 2.0; // 默认圆角为高度的一半
        _backgroundColor = [UIColor whiteColor];
        _selectedTintColor = [UIColor systemPinkColor];
        _normalTintColor = [UIColor grayColor];
        _currentIndex = 0;
        
        _badgeBackgroundColor = [UIColor redColor];
        _badgeTextColor = [UIColor whiteColor];
        _badgeFont = [UIFont boldSystemFontOfSize:7];
        _badgeMinWidth = 14.0;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 1. 绘制背景（用 CAShapeLayer 避免离屏渲染）
    _backgroundLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.fillColor = _backgroundColor.CGColor;
    _backgroundLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    _backgroundLayer.shadowOffset = CGSizeMake(0, 2);
    _backgroundLayer.shadowOpacity = 0.2;
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
    
    // 2. 创建按钮
    _itemButtons = [NSMutableArray array];
    _badgeLabels = [NSMutableArray array];
    CGFloat buttonW = self.bounds.size.width / _icons.count;
    CGFloat buttonH = self.bounds.size.height;
    
    for (NSInteger i = 0; i < _icons.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        [button setImage:_icons[i] forState:UIControlStateNormal];
        [button setImage:_selectIcons[i] forState:UIControlStateSelected];
        [button setTintColor:_normalTintColor];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self addSubview:button];
        [_itemButtons addObject:button];
        
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.backgroundColor = _badgeBackgroundColor;
        badgeLabel.textColor = _badgeTextColor;
        badgeLabel.font = _badgeFont;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.layer.cornerRadius = _badgeMinWidth / 2.0;
        badgeLabel.clipsToBounds = YES;
        badgeLabel.hidden = YES; // 默认隐藏
        [button addSubview:badgeLabel]; // 角标添加到按钮上，跟随按钮移动
        [_badgeLabels addObject:badgeLabel];
    }
    
    // 初始选中第一个按钮
    [self selectItemAtIndex:0];
}

- (void)buttonClicked:(UIButton *)button {
    NSInteger index = button.tag;
    [self selectItemAtIndex:index];
    if (self.itemClickBlock) {
        self.itemClickBlock(index);
    }
}

- (void)selectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= _itemButtons.count) return;
    
    // 重置所有按钮状态
    for (UIButton *button in _itemButtons) {
        button.selected = NO;
        [button setTintColor:_normalTintColor];
    }
    
    // 设置当前按钮状态
    UIButton *currentButton = _itemButtons[index];
    currentButton.selected = YES;
    [currentButton setTintColor:_selectedTintColor];
    _currentIndex = index;
}

// 适配屏幕旋转或frame变化
- (void)layoutSubviews {
    [super layoutSubviews];
    _backgroundLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius].CGPath;
    
    CGFloat buttonW = self.bounds.size.width / _icons.count;
    CGFloat buttonH = self.bounds.size.height;
    for (NSInteger i = 0; i < _itemButtons.count; i++) {
        UIButton *button = _itemButtons[i];
        button.frame = CGRectMake(i * buttonW, 0, buttonW, buttonH);
        
        // 新增：更新角标位置和大小
       UILabel *badgeLabel = _badgeLabels[i];
       if (!badgeLabel.hidden) {
           CGSize badgeSize = [self calculateBadgeSizeWithText:badgeLabel.text];
           // 角标位置：右上角，x 偏移 2pt，y 偏移 2pt
           CGFloat badgeX = button.bounds.size.width - badgeSize.width - 26;
           CGFloat badgeY = 10;
           badgeLabel.frame = CGRectMake(badgeX, badgeY, badgeSize.width, badgeSize.height);
       }
    }
}

/// 计算角标大小（根据文字长度，最小宽度为 badgeMinWidth）
- (CGSize)calculateBadgeSizeWithText:(nullable NSString *)text {
    if (!text || text.length == 0) {
        // 无文字时，显示小圆点（直径为 badgeMinWidth 的一半）
        CGFloat dotSize = _badgeMinWidth / 2.0;
        return CGSizeMake(dotSize, dotSize);
    }
    // 有文字时，计算文字宽度，最小为 badgeMinWidth
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName: _badgeFont}];
    CGFloat width = MAX(textSize.width + 6, _badgeMinWidth); // 左右各留 3pt 内边距
    CGFloat height = _badgeMinWidth; // 高度固定为最小宽度（圆形/椭圆形）
    return CGSizeMake(width, height);
}
/// 设置角标数值（0 或 nil 隐藏）
- (void)setBadgeValue:(nullable NSString *)value forIndex:(NSInteger)index {
    if (index < 0 || index >= _badgeLabels.count) return;
    
    UILabel *badgeLabel = _badgeLabels[index];
    if (!value || [value isEqualToString:@"0"] || value.length == 0) {
        badgeLabel.hidden = YES;
        return;
    }
    
    badgeLabel.text = value;
    badgeLabel.hidden = NO;
    // 更新角标样式（支持动态修改全局样式后刷新）
    badgeLabel.backgroundColor = _badgeBackgroundColor;
    badgeLabel.textColor = _badgeTextColor;
    badgeLabel.font = _badgeFont;
    badgeLabel.layer.cornerRadius = [self calculateBadgeSizeWithText:value].height / 2.0;
    
    // 强制刷新布局
    [self setNeedsLayout];
}

/// 隐藏角标
- (void)hideBadgeForIndex:(NSInteger)index {
    [self setBadgeValue:nil forIndex:index];
}

/// 显示红点角标（无数值）
- (void)showDotBadgeForIndex:(NSInteger)index {
    if (index < 0 || index >= _badgeLabels.count) return;
    
    UILabel *badgeLabel = _badgeLabels[index];
    badgeLabel.text = nil;
    badgeLabel.hidden = NO;
    badgeLabel.backgroundColor = _badgeBackgroundColor;
    badgeLabel.layer.cornerRadius = (_badgeMinWidth / 2.0) / 2.0; // 红点圆角
    
    [self setNeedsLayout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
