//
//  PGDiamondsListViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/8.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGDiamondsListViewController.h"
#import "PGRechargeViewController.h"
//model
#import "PGRechargeListModel.h"
//view
#import "PGDiamondsCollectionViewCell.h"
#import "PGChoosePayAlertView.h"

@interface PGDiamondsListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet QMUIButton *sureBtn;
@property (nonatomic, strong) PGRechargeListModel * rechargeModel;
@property (nonatomic, strong) PGRechargeListCoinModel * chooseModel;

@end

@implementation PGDiamondsListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [PGUtils getUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
    self.titleStr = @"糖币充值";
    if (self.isCallRecharge) {
        self.naviView.frame = CGRectMake(0, 0, ScreenWidth, 64);
        self.naviView.backBtn.alpha = 0;
    }
    self.coinLabel.text = [NSString stringWithFormat:@"%.0f",[PGManager shareModel].selfCoin*0.01];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView.mas_bottom).offset(57);
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-10);
    }];
}
- (void)loadData
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    [PGAPIService diamondListWithParameters:@{@"packName":@"ntdlaz"} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.rechargeModel = [PGRechargeListModel mj_objectWithKeyValues:data[@"data"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakself.collectionView selectItemAtIndexPath:defaultIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [weakself collectionView:weakself.collectionView didSelectItemAtIndexPath:defaultIndexPath];
        });
        [weakself.collectionView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rechargeModel.coins.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGDiamondsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGDiamondsCollectionViewCell.class) forIndexPath:indexPath];
    cell.coinModel = self.rechargeModel.coins[indexPath.row];
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

- (IBAction)suerBtnAction:(id)sender {
    if (self.chooseModel == nil) {
        [QMUITips showWithText:@"请选择要充值的钻石"];
        return;
    }
    PGRechargeViewController * vc = [[PGRechargeViewController alloc] init];
    vc.coinModel = self.chooseModel;
    vc.isCallRecharge = self.isCallRecharge;
    [self.navigationController pushViewController:vc animated:YES];
//    WeakSelf(self)
//    [[PGManager shareModel].mainControlAlert closeView];
//    [PGManager shareModel].mainControlAlert = Dialog()
//        .wLevelSet(999)
//        .wTagSet(random()%100000)
//        .wTypeSet(DialogTypeMyView)
//        .wShowAnimationSet(AninatonCurverOn)
//        .wHideAnimationSet(AninatonCurverOff)
//        .wPointSet(CGPointMake(0, ScreenHeight-280-SafeBottom))
//        .wShadowCanTapSet(YES)
//        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
//            mainView.backgroundColor = [UIColor clearColor];
//            PGChoosePayAlertView *view = [[PGChoosePayAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280+SafeBottom) superView:mainView];
//                
//                return view;
//            })
//        .wStart();
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
