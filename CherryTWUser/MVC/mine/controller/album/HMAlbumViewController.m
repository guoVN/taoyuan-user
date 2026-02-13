//
//  HMAlbumViewController.m
//  CherryTWanchor
//
//  Created by guo on 2025/8/28.
//

#import "HMAlbumViewController.h"
#import "HMAlbumEditViewController.h"
#import "HMAlbumCollectionViewCell.h"
#import "HMAlbumListModel.h"

@interface HMAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray * photoArray;

@end

@implementation HMAlbumViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.titleStr = Localized(@"相册管理");
    self.view.backgroundColor = UIColor.whiteColor;
    [self.naviView.navImg setImage:MPImage(@"liushuiBavBg")];
    self.naviView.showNavImg = YES;
    [self.naviView.rightBtn setTitle:Localized(@"修改") forState:UIControlStateNormal];
    [self.naviView.rightBtn setTitleColor:HEX(#003CFF) forState:UIControlStateNormal];
    [self.naviView.rightBtn addTarget:self action:@selector(rightBntAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
}
- (void)loadData
{
    WeakSelf(self)
    [QMUITips showLoadingInView:self.view];
    [HMNetService myAlbumWithParameters:@{@"userId":[HMManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.photoArray = [HMAlbumListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
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
    return self.photoArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMAlbumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMAlbumCollectionViewCell.class) forIndexPath:indexPath];
    cell.model = self.photoArray[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-26-10)/3.0, (ScreenWidth-26-10)/3.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(13, 13, 13, 13);
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
    NSMutableArray * imgArr = [NSMutableArray array];
    for (NSInteger i=0; i<self.photoArray.count; i++) {
        HMAlbumListModel * model = self.photoArray[i];
        [imgArr addObject:model.photoUrl];
    }
    YBImageView *imgView = [[YBImageView alloc] initWithImageArray:imgArr andIndex:indexPath.row andBlock:^(NSArray * _Nonnull array) {
    }];
    [[UIApplication sharedApplication].delegate.window addSubview:imgView];
}
/// 空数据UI
/// @param scrollView tableview
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = Localized(@"暂无图片");
    NSDictionary *attributes = @{NSFontAttributeName: MPFont(16),
                                 NSForegroundColorAttributeName: HEX(#000000)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return MPImage(@"empty");
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView; {
    return 0;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -STATUS_H_F;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}


- (void)rightBntAction
{
    HMAlbumEditViewController * vc = [[HMAlbumEditViewController alloc] init];
    vc.photoArray = self.photoArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HMAlbumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMAlbumCollectionViewCell"];
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
- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
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
