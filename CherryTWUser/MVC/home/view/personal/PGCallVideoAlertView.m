//
//  PGCallVideoAlertView.m
//  CherryTWUser
//
//  Created by guo on 2025/11/19.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGCallVideoAlertView.h"
#import "PGPersonalYuYueAlertCollectionViewCell.h"

@interface PGCallVideoAlertView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) NSInteger timePrice;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) NSInteger timeDuration;

@end

@implementation PGCallVideoAlertView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [superView addSubview:self];
        self.backgroundColor = HEX(#FFFFFF);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    [self addSubview:self.topView];
    [self addSubview:self.headImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
}
- (void)snapSubView
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(149);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(90);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(23);
        make.height.mas_equalTo(72);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.collectionView.mas_bottom).offset(20);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(-20);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.collectionView.mas_bottom).offset(20);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(46);
    }];
}
- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:detailModel.photo]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",detailModel.nickName];
}
- (void)judgeCoin
{
    NSInteger coin = 0;
    NSInteger totalPrice = self.timePrice+coin/100;
    self.totalPrice = totalPrice;
}

#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGPersonalYuYueAlertCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGPersonalYuYueAlertCollectionViewCell.class) forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.detailModel = self.detailModel;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((305-32-12)/3, 72);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 16, 0, 16);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGPersonalYuYueAlertCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.chooseImg.alpha = 1;
    cell.cardView.layer.borderColor = HEX(#FF6B97).CGColor;
    if (indexPath.row == 0) {
        self.timePrice = [self.detailModel.textChatCoin integerValue]/100;
    }else if (indexPath.row == 1){
        self.timePrice = [self.detailModel.voiceCoin integerValue]/100;
    }else if (indexPath.row == 2){
        self.timePrice = [self.detailModel.videoCoin integerValue]/100;
    }
    self.timeDuration = 10*indexPath.row+10;
    [self judgeCoin];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGPersonalYuYueAlertCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.chooseImg.alpha = 0;
    cell.cardView.layer.borderColor = HEXAlpha(#000000, 0.1).CGColor;
}

- (void)sureBtnAction
{
    
    [[PGManager shareModel].mainControlAlert closeView];
}
- (void)closeAlert
{
    [[PGManager shareModel].mainControlAlert closeView];
}

#pragma mark===懒加载
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 305, 149)];
        [_topView yd_setVeticalGradualFromColor:HEXAlpha(#F1584B, 0.4) toColor:HEXAlpha(#FFFFFF, 0)];
    }
    return _topView;
}
- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.clipsToBounds = YES;
        _headImg.layer.borderWidth = 2;
        _headImg.layer.borderColor = HEX(#FFFFFF).CGColor;
        _headImg.layer.cornerRadius = 45;
        _headImg.layer.masksToBounds = YES;
        [_headImg setImage:MPImage(@"womanDefault")];
    }
    return _headImg;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = MPMediumFont(14);
        _nameLabel.textColor = HEX(#000000);
        _nameLabel.text = @"预约·Flame 姐姐";
    }
    return _nameLabel;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"PGPersonalYuYueAlertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGPersonalYuYueAlertCollectionViewCell"];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = UICollectionViewFlowLayout.new;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.estimatedItemSize = CGSizeZero;
    }
    return _flowLayout;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = HEX(#FF6B97);
        [_sureBtn setTitle:Localized(@"确认") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = MPMediumFont(16);
        _sureBtn.layer.cornerRadius = 23;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:Localized(@"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MPFont(16);
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = HEX(#000000).CGColor;
        _cancelBtn.layer.cornerRadius = 23;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
