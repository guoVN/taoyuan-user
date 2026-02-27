//
//  PGQinmiViewController.m
//  CherryTWUser
//
//  Created by guo on 2026/2/27.
//  Copyright © 2026 guo. All rights reserved.
//

#import "PGQinmiViewController.h"
#import "PGQinmiCollectionViewCell.h"
#import "HMIntimacyListModel.h"
#import "PGChatViewController.h"

@interface PGQinmiViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray * dataArray;


@end

@implementation PGQinmiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
}
- (void)loadUI
{
    self.titleStr = @"亲密度";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
}
- (void)loadData
{
    WeakSelf(self)
    [PGAPIService intimacyListWithParameters:@{@"userId":[PGManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        NSArray * items = [HMIntimacyListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        weakself.dataArray = [NSMutableArray arrayWithArray:items];
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
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGQinmiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGQinmiCollectionViewCell.class) forIndexPath:indexPath];
    cell.listModel = self.dataArray[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 130);
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
    HMIntimacyListModel * listModel = self.dataArray[indexPath.row];
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.channelId = listModel.userid;
    vc.friendHead = listModel.photo;
    vc.friendName = listModel.nickName;
    [self.navigationController pushViewController:vc animated:YES];
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PGQinmiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGQinmiCollectionViewCell"];
//        WeakSelf(self)
//        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            self->page = 1;
//            [weakself loadData];
//        }];
//        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            self->page++;
//            [weakself loadData];
//        }];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
