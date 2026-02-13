//
//  HMYuYueRecordTableViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/14.
//

#import "HMYuYueRecordTableViewCell.h"
#import "HMYuYueProjectCollectionViewCell.h"

@interface HMYuYueRecordTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation HMYuYueRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.projectView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(HMYuYueRecordListModel *)listModel
{
    _listModel = listModel;
    self.nickNameLabel.text = listModel.anchorNickName;
    self.IDLabel.text = [NSString stringWithFormat:@"%ld",listModel.anchorId];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",listModel.scheduleDate,listModel.timePeriod];
    self.minLabel.text = [NSString stringWithFormat:@"%ld分钟",listModel.reservationDuration];
    switch (listModel.reservationStatus) {
        case 1:
            self.statusLabel.text = Localized(@"待确认");
            break;
        case 2:
            self.statusLabel.text = Localized(@"已预约");
            break;
        case 3:
            self.statusLabel.text = Localized(@"已拒绝");
            break;
        case 4:
            self.statusLabel.text = Localized(@"已完成");
            break;
        case 5:
            self.statusLabel.text = Localized(@"已超时");
            break;
        default:
            break;
    }
    self.projectTitleLabel.text = listModel.femaleAdditionalConfigList.count > 0 ? Localized(@"附加项目：") : Localized(@"附加项目：无");
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
    return self.listModel.femaleAdditionalConfigList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMYuYueProjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMYuYueProjectCollectionViewCell.class) forIndexPath:indexPath];
    cell.model = self.listModel.femaleAdditionalConfigList[indexPath.row];
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
    
    // 3. 计算3个cell的总可用宽度（减去2个间距：3个cell有2个间距）
    CGFloat totalCellWidth = validWidth - 9*2; // 间距9，2个间距
    
    // 4. 单个cell宽度（平均分配，向下取整避免超出）
    CGFloat cellWidth = floor(totalCellWidth / 3);
    
    // 5. 固定高度30
    return CGSizeMake(cellWidth, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
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
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HMYuYueProjectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMYuYueProjectCollectionViewCell"];
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

@end
