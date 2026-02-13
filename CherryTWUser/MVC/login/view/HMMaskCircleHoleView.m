//
//  HMMaskCircleHoleView.m
//  CherryTWanchor
//
//  Created by guo on 2025/11/5.
//

#import "HMMaskCircleHoleView.h"

@implementation HMMaskCircleHoleView
{
   CAShapeLayer *_maskLayer;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
   if (self) {
       [self setupMask];
       self.circleRadius = 80;
       // 关键1：设置遮罩的颜色（半透明黑，可自定义）
       self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
   }
   return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
   self = [super initWithCoder:coder];
   if (self) {
       [self setupMask];
       self.circleRadius = 80;
       self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
   }
   return self;
}

#pragma mark - 核心：初始化遮罩（控制显示区域）
- (void)setupMask {
   _maskLayer = [CAShapeLayer layer];
   _maskLayer.fillRule = kCAFillRuleEvenOdd; // 镂空核心
   // 关键2：maskLayer 仅控制“显示/隐藏”，fillColor 设为黑色（不透明=显示原视图）
   _maskLayer.fillColor = HEXAlpha(#000000, 0.6).CGColor;
   self.layer.mask = _maskLayer;
}

#pragma mark - 更新遮罩路径（确保镂空生效）
- (void)updateMaskPath {
   CGRect bounds = self.bounds;
   if (CGRectIsEmpty(bounds)) return;
   
   // 容错：确保半径不超过视图宽高的一半（避免圆形超出遮罩范围）
   CGFloat maxValidRadius = MIN(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
   CGFloat realRadius = MIN(_circleRadius, maxValidRadius);
   
   // 1. 绘制遮罩整体区域（矩形）
   UIBezierPath *totalPath = [UIBezierPath bezierPathWithRect:bounds];
   // 2. 绘制中间镂空圆形（居中）
   CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
   UIBezierPath *holePath = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:realRadius
                                                       startAngle:0
                                                         endAngle:M_PI * 2
                                                        clockwise:YES];
   // 3. 追加圆形路径，启用镂空（圆形区域隐藏遮罩）
   [totalPath appendPath:holePath];
   totalPath.usesEvenOddFillRule = YES;
   
   _maskLayer.path = totalPath.CGPath;
   _maskLayer.frame = bounds; // 确保遮罩路径与视图大小一致
}

#pragma mark - 属性 setter
- (void)setCircleRadius:(CGFloat)circleRadius {
   _circleRadius = circleRadius;
   [self updateMaskPath];
}

#pragma mark - 视图大小变化时同步更新遮罩
- (void)layoutSubviews {
   [super layoutSubviews];
   [self updateMaskPath];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
