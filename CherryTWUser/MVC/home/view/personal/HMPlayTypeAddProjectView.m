//
//  HMPlayTypeAddProjectView.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/21.
//

#import "HMPlayTypeAddProjectView.h"
#import "HMPlayTypeChooseProjectCollectionViewCell.h"

@interface HMPlayTypeAddProjectView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * chooseArray;

@end

@implementation HMPlayTypeAddProjectView

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
    [self addSubview:self.collectionView];
    [self addSubview:self.sureBtn];
}
- (void)snapSubView
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.height.mas_equalTo(25);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-10);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-SafeBottom-20);
        make.height.mas_equalTo(50);
    }];
}
- (void)setProjectModel:(HMPlayTypeProjectModel *)projectModel
{
    _projectModel = projectModel;
    [self.dataArray removeAllObjects];
    [self.chooseArray removeAllObjects];
    [self.chooseArray addObjectsFromArray:projectModel.selectorConfigs];
    [self.dataArray addObjectsFromArray:projectModel.femaleAdditionalConfigList];
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
    HMPlayTypeChooseProjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMPlayTypeChooseProjectCollectionViewCell.class) forIndexPath:indexPath];
    HMPlayTypeProjectListModel * listModel = self.dataArray[indexPath.row];
    cell.listModel = listModel;
    if ([self.chooseArray containsObject:listModel]) {
        cell.chooseImg.alpha = 1;
        cell.backView.layer.borderColor = HEX(#FF6B97).CGColor;
        cell.backView.backgroundColor = HEX(#FFF6F9);
    }else{
        cell.chooseImg.alpha = 0;
        cell.backView.layer.borderColor = HEXAlpha(#000000, 0.2).CGColor;
        cell.backView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-50)/2, 55);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMPlayTypeProjectListModel * listModel = self.dataArray[indexPath.row];
    if ([self.chooseArray containsObject:listModel]) {
        [self.chooseArray removeObject:listModel];
    }else{
        [self.chooseArray addObject:listModel];
    }
    [self.collectionView reloadData];
}


- (void)sureBtnAction
{
    self.sureBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sureBtn.enabled = YES;
    });
    NSMutableArray * idArr = [NSMutableArray array];
    for (HMPlayTypeProjectListModel * listModel in self.chooseArray) {
        [idArr addObject:@(listModel.ID)];
    }
    if (self.chooseProjectBlock) {
        self.chooseProjectBlock(self.chooseArray);
    }
    [[PGManager shareModel].addProjectlAlert closeView];
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:[HMManager shareModel].userInfo.userid forKey:@"anchorId"];
//    [dic setValue:idArr forKey:@"configIds"];
//    WeakSelf(self)
//    [HMNetService updateReservationConfigInfoWithParameters:dic Success:^(id  _Nonnull data) {
//        if (weakself.chooseProjectBlock) {
//            weakself.chooseProjectBlock(weakself.chooseArray);
//        }
//        [[HMManager shareModel].playChooseProjectAlert closeView];
//    } failure:^(NSInteger code, NSString * _Nonnull message) {
//        
//    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPMediumFont(18);
        _titleLabel.textColor = HEX(#000000);
        _titleLabel.text = Localized(@"附加项目");
    }
    return _titleLabel;
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
        [_collectionView registerNib:[UINib nibWithNibName:@"HMPlayTypeChooseProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMPlayTypeChooseProjectCollectionViewCell"];
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
        _sureBtn.titleLabel.font = MPSemiboldFont(18);
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
