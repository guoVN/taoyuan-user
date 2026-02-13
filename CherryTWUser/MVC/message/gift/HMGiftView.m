//
//  HMGiftView.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/22.
//

#import "HMGiftView.h"
#import "HMPlayTypeUpdatePriceCollectionViewCell.h"

@interface HMGiftView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * chooseArray;

@end

@implementation HMGiftView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [superView addSubview:self];
        self.backgroundColor = HEX(#2E2E2E);
        [self initSubView];
        [self snapSubView];
//        [PGUtils getUserInfo];
        if ([PGManager shareModel].giftArray.count==0) {
            [self loadGiftData];
        }else{
            [self updateData:[PGManager shareModel].giftArray];
        }
    }
    return self;
}
- (void)initSubView
{
    [self acs_radiusWithRadius:20 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    [self addSubview:self.titleLabel];
    [self addSubview:self.totalDiamondLabel];
    [self addSubview:self.collectionView];
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
        make.top.mas_equalTo(40);
        make.bottom.mas_equalTo(-SafeBottom);
    }];
}
- (void)loadGiftData
{
    WeakSelf(self)
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    [PGAPIService diamondListWithParameters:@{@"packName":@"ntdlaz"} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        PGRechargeListModel * rechargeModel = [PGRechargeListModel mj_objectWithKeyValues:data[@"data"]];
        [PGManager shareModel].giftArray = [rechargeModel.otherSetting.presentCoins mutableCopy];
        [weakself updateData:rechargeModel.otherSetting.presentCoins];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)updateData:(NSArray *)items
{
    self.dataArray = [NSMutableArray arrayWithArray:items];
    [self.collectionView reloadData];
}

#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self)
    HMPlayTypeUpdatePriceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMPlayTypeUpdatePriceCollectionViewCell.class) forIndexPath:indexPath];
    cell.giftModel = self.dataArray[indexPath.row];
    if (cell.giftModel == self.chooseArray.firstObject) {
        cell.chooseView.alpha = 1;
    }else{
        cell.chooseView.alpha = 0;
    }
    cell.chooseBlock = ^(PGGiftListModel * _Nonnull chooseModel) {
        [weakself sendGift];
    };
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-20)/4-1, 142);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGGiftListModel * model = self.dataArray[indexPath.row];
    [self.chooseArray removeAllObjects];
    [self.chooseArray addObject:model];
    [self.collectionView reloadData];
}
#pragma mark===送礼物
- (void)sendGift
{
    WeakSelf(self)
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.channelId forKey:@"anchorUserid"];
    [dic setValue:@"" forKey:@"virtualAnchorId"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:[PGManager shareModel].currentChooseGiftModel.name forKey:@"giftType"];
    [dic setValue:@([PGManager shareModel].currentChooseGiftModel.coin) forKey:@"coin"];
    [dic setValue:@"0" forKey:@"callid"];
    [dic setValue:@"ntdlaz" forKey:@"packName"];
    [PGAPIService sendGiftWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [PGManager shareModel].selfCoin -= [PGManager shareModel].currentChooseGiftModel.coin;
//        weakself.diamondLabel.text = [NSString stringWithFormat:@"糖币余额：%.0f",[PGManager shareModel].selfCoin*0.01];
        PGTabbarViewController * tabbar = (PGTabbarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabbar showSvga:[PGManager shareModel].currentChooseGiftModel.dynamicPic];
        if (weakself.sendGiftBlock) {
            weakself.sendGiftBlock([PGManager shareModel].currentChooseGiftModel.name);
        }
        [weakself removeFromSuperview];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        if ([message containsString:@"金币不足"]) {
            [weakself removeFromSuperview];
            [PGUtils goRechargeAlert];
        }
    }];
}
#pragma mark===懒加载
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPMediumFont(18);
        _titleLabel.textColor = HEX(#FFFFFF);
        _titleLabel.text = Localized(@"糖币余额");
    }
    return _titleLabel;
}
- (UILabel *)totalDiamondLabel
{
    if (!_totalDiamondLabel) {
        _totalDiamondLabel = [[UILabel alloc] init];
        _totalDiamondLabel.font = MPMediumFont(18);
        _totalDiamondLabel.textColor = HEX(#FFFFFF);
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f ",[PGManager shareModel].selfCoin*0.01]];
        NSTextAttachment * attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"diamonds"];
        attach.bounds = CGRectMake(0, -2, 16, 16);
        NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
        [att appendAttributedString:attrStringWithImage];
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
        [_collectionView registerNib:[UINib nibWithNibName:@"HMPlayTypeUpdatePriceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMPlayTypeUpdatePriceCollectionViewCell"];
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
