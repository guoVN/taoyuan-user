//
//  UITableViewCell+PGCellShaow.m
//  CherryTWUser
//
//  Created by guo on 2025/11/17.
//  Copyright © 2025 guo. All rights reserved.
//

#import "UITableViewCell+PGCellShaow.h"

@implementation UITableViewCell (PGCellShaow)

- (void)setupTopShadowWithCustomView {
    // 创建阴影视图
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 4)];
    
    // 创建渐变层实现阴影效果
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[
        (id)[[UIColor blackColor] colorWithAlphaComponent:0.02].CGColor,
        (id)[[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor
    ];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    
    [shadowView.layer addSublayer:gradient];
    [self.contentView addSubview:shadowView];
}

@end
