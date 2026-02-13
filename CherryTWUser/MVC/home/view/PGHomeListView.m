//
//  PGHomeListView.m
//  CherryTWUser
//
//  Created by guo on 2025/10/23.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGHomeListView.h"
#import "PGHomeAdviceCollectionViewCell.h"
#import "PGPersonalDetailViewController.h"

@interface PGHomeListView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGHomeListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
        [self snapSubView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadData];
        });
    }
    return self;
}
- (UIView *)listView
{
    return self;
}
- (void)initSubView
{
    page = 1;
    [self addSubview:self.collectionView];
}
- (void)snapSubView
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)loadData
{
    if ([PGManager shareModel].baseUrl.length == 0) {
        return;
    }
    WeakSelf(self)
    NSString * timeStampString = [PGUtils getCurrentTimeStamp];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:@(page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"pageSize"];
    [dic setValue:self.index == 0 ? @"1" : @"2" forKey:@"type"];
    NSString * sign = [PGParameterSignTool encoingPameterSignWithDic:[NSMutableDictionary dictionaryWithDictionary:dic] andTimeSta:timeStampString];
    [dic setValue:sign forKey:@"sign"];
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    [PGAPIService homeRemandWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        NSArray * items = [PGHomeListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        if (self->page == 1) {
            [weakself.dataArray removeAllObjects];
        }
        if (items.count<=0) {
            [weakself.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [weakself.dataArray addObjectsFromArray:items];
        }
        [weakself.collectionView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
    }];
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGHomeAdviceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGHomeAdviceCollectionViewCell.class) forIndexPath:indexPath];
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-45)*0.5, 220);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGHomeListModel * listModel = self.dataArray[indexPath.row];
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = [NSString stringWithFormat:@"%ld",listModel.userid];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
#pragma mark===懒加载
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PGHomeAdviceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGHomeAdviceCollectionViewCell"];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
