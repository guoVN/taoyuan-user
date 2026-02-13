//
//  PGYuYueTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/10/24.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGYuYueTableViewCell.h"
#import "HMYuYueListCollectionReusableView.h"
#import "HMYuYueListCollectionViewCell.h"
#import "PGPersonalYuYueAlertView.h"

@interface PGYuYueTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSDate * currentDate;       // 当前显示的日期
@property (nonatomic, assign) NSInteger daysFromToday;   // 与今天的天数差（0=今天，-1=昨天，最多到-6）
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray * dataArray;
///查询日期
@property (nonatomic, copy) NSString * checkDay;

@end

@implementation PGYuYueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupTopShadowWithCustomView];
    self.nextDayBtn.imagePosition = QMUIButtonImagePositionRight;
    self.lastDayBtn.jk_touchAreaInsets = self.nextDayBtn.jk_touchAreaInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.yuyueView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.checkDay = [formatter stringFromDate:currentDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
}
- (void)setYuYueModel:(PGYuYueModel *)yuYueModel
{
    _yuYueModel = yuYueModel;
    [self.collectionView reloadData];
    // 关键：强制collectionView完成布局，确保contentSize正确
   [self.collectionView layoutIfNeeded];
   
   // 更新projectView的高度约束
   self.yuyueViewHC.constant = self.collectionView.contentSize.height;
   // 强制projectView刷新布局，使约束生效
   [self.yuyueView layoutIfNeeded];
}

- (IBAction)lastDayBtnAction:(id)sender {
    if (self.daysFromToday > -1) { // 未超过“最多前推6天”的限制
        self.daysFromToday--;
        
        // 计算“上一日”的日期
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = self.daysFromToday;
        self.currentDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
        
        NSDateFormatter *cformatter = [[NSDateFormatter alloc] init];
        [cformatter setDateFormat:@"YYYY-MM-dd"];
        self.checkDay = [cformatter stringFromDate:self.currentDate];
        if (self.changeDayBlock) {
            self.changeDayBlock(self.checkDay);
        }
        
        if (self.daysFromToday == 0) {
            self.currentDayLabel.text = @"今天";
            self.lastDayBtn.hidden = YES; // 回到今天，隐藏“下一日”
            self.titleLabel.alpha = 1;
        }else{
            // 更新日期标签显示（格式：MM月dd日）
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM月dd日"];
            self.currentDayLabel.text = [formatter stringFromDate:self.currentDate];
        }
        
        // 显示“下一日”按钮
        self.nextDayBtn.hidden = NO;
        
        // 若已推到6天前，禁用“上一日”按钮
        if (self.daysFromToday == -1) {
            self.lastDayBtn.enabled = NO;
            self.lastDayBtn.hidden = YES;
        }
    }
}
- (IBAction)nextDayBtnAction:(id)sender {
    self.titleLabel.alpha = 0;
    if (self.daysFromToday < 5) {
        self.daysFromToday++;
            
        // 计算“下一日”的日期
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = self.daysFromToday;
        self.currentDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
        NSDateFormatter *cformatter = [[NSDateFormatter alloc] init];
        [cformatter setDateFormat:@"YYYY-MM-dd"];
        self.checkDay = [cformatter stringFromDate:self.currentDate];
        if (self.changeDayBlock) {
            self.changeDayBlock(self.checkDay);
        }
        
        // 更新日期标签显示
        if (self.daysFromToday == 0) {
            self.currentDayLabel.text = @"今天";
            self.lastDayBtn.hidden = YES; // 回到今天，隐藏“下一日”
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM月dd日"];
            self.currentDayLabel.text = [formatter stringFromDate:self.currentDate];
            self.lastDayBtn.hidden = NO;
        }
        
        if (self.daysFromToday == 4) {
            self.nextDayBtn.hidden = YES;
        }
        self.lastDayBtn.enabled = YES;
    }
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.yuYueModel.morning.count;
    }else if (section == 1){
        return self.yuYueModel.afternoon.count;
    }else{
        return self.yuYueModel.night.count;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HMYuYueListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(HMYuYueListCollectionViewCell.class) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.timeModel = self.yuYueModel.morning[indexPath.row];
    }else if (indexPath.section == 1){
        cell.timeModel = self.yuYueModel.afternoon[indexPath.row];
    }else if (indexPath.section == 2){
        cell.timeModel = self.yuYueModel.night[indexPath.row];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        HMYuYueListCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HMYuYueListCollectionReusableView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            PGYuYueDataModelTimeModel * first = self.yuYueModel.morning.firstObject;
            PGYuYueDataModelTimeModel * last = self.yuYueModel.morning.lastObject;
            header.titleLabel.text = Localized(@"上午");
            header.timeLabel.text = [NSString stringWithFormat:@"%ld:00-%ld:00",first.hourUnit,last.hourUnit+1];
        }else if (indexPath.section == 1){
            PGYuYueDataModelTimeModel * first = self.yuYueModel.afternoon.firstObject;
            PGYuYueDataModelTimeModel * last = self.yuYueModel.afternoon.lastObject;
            header.titleLabel.text = Localized(@"下午");
            header.timeLabel.text = [NSString stringWithFormat:@"%ld:00-%ld:00",first.hourUnit,last.hourUnit+1];
        }else if (indexPath.section == 2){
            PGYuYueDataModelTimeModel * first = self.yuYueModel.night.firstObject;
            PGYuYueDataModelTimeModel * last = self.yuYueModel.night.lastObject;
            header.titleLabel.text = Localized(@"晚间");
            header.timeLabel.text = [NSString stringWithFormat:@"%ld:00-%ld:00",first.hourUnit,last.hourUnit+1];
        }
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-40-15-1)/4.0, 45);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 45);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGYuYueDataModelTimeModel * timeModel;
    if (indexPath.section == 0) {
        timeModel = self.yuYueModel.morning[indexPath.row];
    }else if (indexPath.section == 1){
        timeModel = self.yuYueModel.afternoon[indexPath.row];
    }else if (indexPath.section == 2){
        timeModel = self.yuYueModel.night[indexPath.row];
    }
    if (timeModel.status == 1 || timeModel.status == 2){
        WeakSelf(self)
        [[PGManager shareModel].mainControlAlert closeView];
        [PGManager shareModel].mainControlAlert = Dialog()
            .wLevelSet(999)
            .wTagSet(random()%100000)
            .wTypeSet(DialogTypeMyView)
            .wShowAnimationSet(AninatonZoomInCombin)
            .wHideAnimationSet(AninatonZoomOut)
            .wShadowCanTapSet(YES)
            .wPointSet(CGPointMake(0, 0))
            .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
                mainView.backgroundColor = [UIColor clearColor];
                PGPersonalYuYueAlertView *view = [[PGPersonalYuYueAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) superView:mainView];
                    view.scheduleDate = self.checkDay;
                    view.hourUnit = timeModel.hourUnit;
                    view.tipsStr = weakself.yuYueModel.tips;
                    view.detailModel = weakself.detailModel;
                    return view;
                })
            .wStart();
    }
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
        [_collectionView registerNib:[UINib nibWithNibName:@"HMYuYueListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HMYuYueListCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"HMYuYueListCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HMYuYueListCollectionReusableView"];
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
