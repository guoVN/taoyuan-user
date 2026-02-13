//
//  HMAlbumAndVideoCollectionReusableView.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/12.
//

#import "HMAlbumAndVideoCollectionReusableView.h"

@implementation HMAlbumAndVideoCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.titleLabel];
}
- (void)snapSubView
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(22);
    }];
}

#pragma mark===懒加载
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPSemiboldFont(16);
        _titleLabel.textColor = HEX(#222222);
        _titleLabel.text = Localized(@"相册");
    }
    return _titleLabel;
}

@end
