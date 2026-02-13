//
//  PGRechargeAlertView.m
//  CherryTWUser
//
//  Created by guo on 2025/11/3.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGRechargeAlertView.h"
#import "PGDiamondsCollectionViewCell.h"

@interface PGRechargeAlertView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * chooseArray;
@property (nonatomic, strong) PGRechargeListModel * rechargeModel;
@property (nonatomic, strong) PGRechargeListCoinModel * chooseModel;

@end

@implementation PGRechargeAlertView

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
    [self acs_radiusWithRadius:20 corner:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self addSubview:self.titleLabel];
    [self addSubview:self.totalDiamondLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.sureBtn];
}
- (void)snapSubView
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.height.mas_equalTo(25);
    }];
    [self.totalDiamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(25);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.bottom.mas_equalTo(-SafeBottom-80);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-SafeBottom-20);
        make.height.mas_equalTo(50);
    }];
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;//self.rechargeModel.coins.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGDiamondsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGDiamondsCollectionViewCell.class) forIndexPath:indexPath];
//    cell.coinModel = self.rechargeModel.coins[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-45)/2.0, 85);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 9;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.chooseModel = self.rechargeModel.coins[indexPath.row];
    PGDiamondsCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = HEX(#FFF6F9);
    cell.layer.borderColor = HEX(#FF6B97).CGColor;
    cell.priceLabel.textColor = HEX(#FF6B97);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGDiamondsCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.borderColor = HEXAlpha(#000000, 0.1).CGColor;
    cell.priceLabel.textColor = HEX(#999999);
}

- (void)sureBtnAction
{
    
}

#pragma mark===懒加载
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPFont(18);
        _titleLabel.textColor = HEX(#000000);
        _titleLabel.text = Localized(@"钻石余额");
    }
    return _titleLabel;
}
- (UILabel *)totalDiamondLabel
{
    if (!_totalDiamondLabel) {
        _totalDiamondLabel = [[UILabel alloc] init];
        _totalDiamondLabel.font = MPMediumFont(18);
        _totalDiamondLabel.textColor = HEX(#0E0E0E);
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",@"18998"]];
        NSTextAttachment * attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"diamonds"];
        attach.bounds = CGRectMake(0, -2, 16, 16);
        NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
        [att insertAttributedString:attrStringWithImage atIndex:0];
        _totalDiamondLabel.attributedText = att;
    }
    return _totalDiamondLabel;
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PGDiamondsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGDiamondsCollectionViewCell"];
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
        [_sureBtn setTitle:Localized(@"确定充值") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = MPSemiboldFont(20);
        _sureBtn.layer.cornerRadius = 25;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)chooseArray
{
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
    }
    return _chooseArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
