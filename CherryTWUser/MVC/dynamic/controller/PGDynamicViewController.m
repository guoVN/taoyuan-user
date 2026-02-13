//
//  PGDynamicViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGDynamicViewController.h"
#import "PGPublishDynamicViewController.h"
#import "PGWaterFollowLayout.h"
#import "PGPersonalDetailViewController.h"
//model
#import "PGAnchorModel.h"
#import "PGDynamicNoticeModel.h"
//view
#import "PGDynamicListCollectionViewCell.h"
#import "PGDynamicHeaderView.h"

@interface PGDynamicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PGWaterFollowLayoutDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UIImageView * topBg;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) PGWaterFollowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * cellHeightArray;
@property (nonatomic, strong) UILabel * titleBtn;

@end

@implementation PGDynamicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNotice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
    self.view.backgroundColor = HEX(#EDEEF2);
    [self.view addSubview:self.topBg];
    [self.topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(466);
    }];
    [self.view addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(STATUS_H_F+19);
        make.height.mas_equalTo(29);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+68);
    }];
}
- (void)loadData
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@"10" forKey:@"pageSize"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService dynamicListWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        NSArray * items = [PGAnchorDynamicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        if (self->page == 1) {
            [weakself.dataArray removeAllObjects];
            [weakself.cellHeightArray removeAllObjects];
        }
        [weakself.dataArray addObjectsFromArray:items];
        for (NSInteger i=0; i<items.count; i++) {
            CGFloat imageH = i == 1 ? 246 : 226;
            CGFloat cellHeght = imageH + 62;
            [weakself.cellHeightArray addObject:@(cellHeght)];
        }
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        [weakself.collectionView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
    }];
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
- (void)loadNotice
{
//    WeakSelf(self)
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
//    [PGAPIService dynamicDetailAndNoticeWithParameters:dic Success:^(id  _Nonnull data) {
//        weakself.noticeArray = [PGDynamicNoticeModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
//        weakself.noticeHeader.noticeArray = weakself.noticeArray;
//        [weakself.tableView reloadData];
//    } failure:^(NSInteger code, NSString * _Nonnull message) {
//        
//    }];
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGDynamicListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGDynamicListCollectionViewCell.class) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGAnchorDynamicModel * model = self.dataArray[indexPath.row];
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = [NSString stringWithFormat:@"%ld",model.userid];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - PGWaterFollowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(0, [self.cellHeightArray[(indexPath.section) * 10 + indexPath.row] floatValue]);
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
/** 脚视图Size */
-(CGSize )waterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout{
    return 2;
}
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout{
    if (self.dataArray.count%2 == 0) {
        return self.dataArray.count/2.0;
    }
    return self.dataArray.count/2.0+1;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout{
    return 7;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout{
    return 7;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(PGWaterFollowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

#pragma mark-======创建表视图
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PGDynamicListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGDynamicListCollectionViewCell"];
        WeakSelf(self)
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->page = 1;
            [weakself loadData];
        }];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self->page++;
            [weakself loadData];
        }];
        
        _collectionView.mj_footer.ignoredScrollViewContentInsetBottom = 90;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
    }
    return _collectionView;
}
- (PGWaterFollowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = PGWaterFollowLayout.new;
        _flowLayout.delegate = self;
        _flowLayout.flowLayoutStyle = PGWaterFlowVerticalEqualWidth;
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
- (NSMutableArray *)cellHeightArray
{
    if (!_cellHeightArray) {
        _cellHeightArray = [NSMutableArray array];
    }
    return _cellHeightArray;
}

- (UILabel *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[UILabel alloc] init];
        _titleBtn.font = MPSemiboldFont(24);
        _titleBtn.textColor = HEX(#000000);
        _titleBtn.text = Localized(@"广场");
    }
    return _titleBtn;
}
- (UIImageView *)topBg
{
    if (!_topBg) {
        _topBg = [[UIImageView alloc] init];
        [_topBg setImage:MPImage(@"homeBg")];
        _topBg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topBg;
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
