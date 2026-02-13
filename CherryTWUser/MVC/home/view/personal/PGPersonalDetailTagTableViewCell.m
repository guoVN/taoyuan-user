//
//  PGPersonalDetailTagTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPersonalDetailTagTableViewCell.h"
#import "PGPersonalProjectCollectionViewCell.h"

@interface PGPersonalDetailTagTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) BOOL isRefreshed;

@end

@implementation PGPersonalDetailTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupTopShadowWithCustomView];
    [self.projectView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
    if (detailModel.customSign.length == 0 && detailModel.femaleAdditionalConfigList.count == 0) {
        self.titleLabel.alpha = 0;
    }else{
        self.titleLabel.alpha = 1;
    }
    self.customLabel.text = detailModel.customSign;
    self.customLabelBC.constant = detailModel.customSign.length>0?15:0;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:detailModel.femaleAdditionalConfigList];
    [self.collectionView reloadData];
    // 关键：强制collectionView完成布局，确保contentSize正确
   [self.collectionView layoutIfNeeded];
   
   // 更新projectView的高度约束
   self.projectViewHC.constant = self.collectionView.contentSize.height;
   // 强制projectView刷新布局，使约束生效
   [self.projectView layoutIfNeeded];
}

#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGPersonalProjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGPersonalProjectCollectionViewCell.class) forIndexPath:indexPath];
    cell.menuModel = self.dataArray[indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
// 1. 获取collectionView的实际宽度（即projectView的宽度，因为collectionView边缘对齐projectView）
    CGFloat collectionViewWidth = CGRectGetWidth(self.projectView.bounds);
    
    // 2. 计算有效宽度（减去左右sectionInset）
    CGFloat validWidth = collectionViewWidth - 15 - 15; // 左15 + 右15
    
    // 3. 计算2个cell的总可用宽度（减去1个间距：2个cell有1个间距）
    CGFloat totalCellWidth = validWidth - 50; // 间距50，1个间距
    
    // 4. 单个cell宽度（平均分配，向下取整避免超出）
    CGFloat cellWidth = floor(totalCellWidth / 2);
    
    // 5. 固定高度20
    return CGSizeMake(cellWidth, 20);
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PGPersonalProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGPersonalProjectCollectionViewCell"];
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

@end
