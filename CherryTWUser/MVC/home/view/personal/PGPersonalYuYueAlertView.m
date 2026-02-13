//
//  PGPersonalYuYueAlertView.m
//  CherryTWUser
//
//  Created by guo on 2025/11/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPersonalYuYueAlertView.h"
#import "PGPersonalYuYueAlertCollectionViewCell.h"
#import "PGPersonalYuYueAlertTableViewCell.h"
#import "HMPlayTypeAddProjectView.h"
#import "HMPlayTypeProjectModel.h"

@interface PGPersonalYuYueAlertView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) HMPlayTypeProjectModel * projectModel;
@property (nonatomic, assign) NSInteger timePrice;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) NSInteger timeDuration;

@end

@implementation PGPersonalYuYueAlertView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [superView addSubview:self];
        self.backgroundColor = [UIColor clearColor];
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlert)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    [self addSubview:self.backView];
    [self.backView addSubview:self.topView];
    [self.backView addSubview:self.headImg];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.collectionView];
    [self.backView addSubview:self.tableView];
    [self.backView addSubview:self.addProjectBtn];
    [self.backView addSubview:self.leftLabel];
    [self.backView addSubview:self.totalDiamondLabel];
    [self.backView addSubview:self.tipsLabel];
    [self.backView addSubview:self.sureBtn];
    [self.backView addSubview:self.cancelBtn];
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(305);
        make.height.mas_greaterThanOrEqualTo(510);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(149);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(90);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(12);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(72);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.collectionView.mas_bottom).offset(16);
        make.height.mas_equalTo(0);
    }];
    [self.addProjectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.tableView.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.addProjectBtn.mas_bottom).offset(18);
        make.height.mas_equalTo(17);
    }];
    [self.totalDiamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.leftLabel.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.leftLabel.mas_bottom).offset(10);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(46);
        make.bottom.mas_equalTo(-20);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(46);
    }];
}
- (void)setHourUnit:(NSInteger)hourUnit
{
    _hourUnit = hourUnit;
}
- (void)setTipsStr:(NSString *)tipsStr
{
    _tipsStr = tipsStr;
}
- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
    [self loadProjectData];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:detailModel.photo]];
    self.nameLabel.text = [NSString stringWithFormat:@"预约·%@",detailModel.nickName];
    self.timeLabel.text = [NSString stringWithFormat:@"(%ld.00-%ld.00)",self.hourUnit,self.hourUnit+1];
    self.tipsLabel.text = self.tipsStr;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.collectionView selectItemAtIndexPath:defaultIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:defaultIndexPath];
    });
}
- (void)judgeCoin
{
    NSInteger coin = 0;
    for (HMPlayTypeProjectListModel * listModel in self.projectModel.selectorConfigs) {
        coin += listModel.giftCoin;
    }
    NSInteger totalPrice = self.timePrice+coin/100;
    self.totalPrice = totalPrice;
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ",totalPrice]];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"diamonds"];
    attach.bounds = CGRectMake(0, -2, 12, 12);
    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
    [att appendAttributedString:attrStringWithImage];
    self.totalDiamondLabel.attributedText = att;
}
- (void)loadProjectData
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.detailModel.userid) forKey:@"anchorId"];
    [dic setValue:self.scheduleDate forKey:@"scheduleDate"];
    [dic setValue:@(self.hourUnit) forKey:@"hourUnit"];
    [PGAPIService checkAnchorProjectWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.projectModel = [HMPlayTypeProjectModel mj_objectWithKeyValues:data[@"data"]];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PGPersonalYuYueAlertCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PGPersonalYuYueAlertCollectionViewCell.class) forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.detailModel = self.detailModel;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((305-32-12)/3, 72);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 16, 0, 16);
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
    PGPersonalYuYueAlertCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.chooseImg.alpha = 1;
    cell.cardView.layer.borderColor = HEX(#FF6B97).CGColor;
    if (indexPath.row == 0) {
        self.timePrice = [self.detailModel.textChatCoin integerValue]/100;
    }else if (indexPath.row == 1){
        self.timePrice = [self.detailModel.voiceCoin integerValue]/100;
    }else if (indexPath.row == 2){
        self.timePrice = [self.detailModel.videoCoin integerValue]/100;
    }
    self.timeDuration = 10*indexPath.row+10;
    [self judgeCoin];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGPersonalYuYueAlertCollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.chooseImg.alpha = 0;
    cell.cardView.layer.borderColor = HEXAlpha(#000000, 0.1).CGColor;
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.backView]) {
        return NO;
    }
    return YES;
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGPersonalYuYueAlertTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGPersonalYuYueAlertTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = self.projectModel.selectorConfigs[indexPath.row];
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark===添加项目
- (void)addProjectBtnAction
{
    WeakSelf(self)
    [[PGManager shareModel].addProjectlAlert closeView];
    [PGManager shareModel].addProjectlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonCurverOn)
        .wHideAnimationSet(AninatonCurverOff)
        .wPointSet(CGPointMake(0, ScreenHeight-454-SafeBottom))
        .wShadowCanTapSet(YES)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMPlayTypeAddProjectView *view = [[HMPlayTypeAddProjectView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 454+SafeBottom) superView:mainView];
                view.projectModel = weakself.projectModel;
                view.chooseProjectBlock = ^(NSMutableArray * _Nonnull chooseArr) {
                    weakself.projectModel.selectorConfigs = chooseArr;
                    weakself.dataArray = chooseArr;
                    CGFloat tH = 40*weakself.dataArray.count;
                    tH = tH > 100 ? 100 : tH;
                    [weakself.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(tH);
                    }];
                    [weakself judgeCoin];
                    [weakself.tableView reloadData];
                };
                return view;
            })
        .wStart();
}
- (void)sureBtnAction
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.detailModel.userid) forKey:@"anchorId"];
    [dic setValue:self.scheduleDate forKey:@"scheduleDate"];
    [dic setValue:@(self.hourUnit) forKey:@"hourUnit"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [dic setValue:@(self.totalPrice*100) forKey:@"coin"];
    [dic setValue:@(self.timeDuration) forKey:@"reservationDuration"];
    
    NSMutableArray * listArr = [NSMutableArray array];
    for (HMPlayTypeProjectListModel * model in self.projectModel.selectorConfigs) {
        NSDictionary * dd = model.mj_keyValues;
        [listArr addObject:dd];
    }
    [dic setValue:listArr forKey:@"femaleAdditionalConfigList"];
    [PGAPIService sureYuYueWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:Localized(@"预约成功")];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
    [[PGManager shareModel].mainControlAlert closeView];
}
- (void)closeAlert
{
    [[PGManager shareModel].mainControlAlert closeView];
}
#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEX(#FFFFFF);
        _backView.layer.cornerRadius = 20;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 305, 149)];
        [_topView yd_setVeticalGradualFromColor:HEXAlpha(#F1584B, 0.4) toColor:HEXAlpha(#FFFFFF, 0)];
    }
    return _topView;
}
- (UIImageView *)headImg
{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.clipsToBounds = YES;
        _headImg.layer.borderWidth = 2;
        _headImg.layer.borderColor = HEX(#FFFFFF).CGColor;
        _headImg.layer.cornerRadius = 45;
        _headImg.layer.masksToBounds = YES;
        [_headImg setImage:MPImage(@"womanDefault")];
    }
    return _headImg;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = MPMediumFont(14);
        _nameLabel.textColor = HEX(#000000);
        _nameLabel.text = @"预约·Flame 姐姐";
    }
    return _nameLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = MPLightFont(12);
        _timeLabel.textColor = HEX(#000000);
        _timeLabel.text = @"（时间：3.00-4.00）";
    }
    return _timeLabel;
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
        [_collectionView registerNib:[UINib nibWithNibName:@"PGPersonalYuYueAlertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PGPersonalYuYueAlertCollectionViewCell"];
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
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            if (@available(iOS 11.0, *)) {
                _tableView.estimatedRowHeight = 0;
                _tableView.estimatedSectionFooterHeight = 0;
                _tableView.estimatedSectionHeaderHeight = 0;
                _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
#endif
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"PGPersonalYuYueAlertTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGPersonalYuYueAlertTableViewCell"];
    }
    return _tableView;
}
- (UIButton *)addProjectBtn
{
    if (!_addProjectBtn) {
        _addProjectBtn = [[UIButton alloc] init];
        [_addProjectBtn setTitle:@"+ 继续添加" forState:UIControlStateNormal];
        [_addProjectBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _addProjectBtn.titleLabel.font = MPLightFont(14);
        _addProjectBtn.layer.borderWidth = 1;
        _addProjectBtn.layer.borderColor = HEX(#000000).CGColor;
        _addProjectBtn.layer.cornerRadius = 10;
        _addProjectBtn.layer.masksToBounds = YES;
        [_addProjectBtn addTarget:self action:@selector(addProjectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addProjectBtn;
}
- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = MPFont(12);
        _leftLabel.textColor = HEX(#000000);
        _leftLabel.text = Localized(@"合计");
    }
    return _leftLabel;
}
- (UILabel *)totalDiamondLabel
{
    if (!_totalDiamondLabel) {
        _totalDiamondLabel = [[UILabel alloc] init];
        _totalDiamondLabel.font = MPFont(14);
        _totalDiamondLabel.textColor = HEX(#000000);
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",@"0"]];
        NSTextAttachment * attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"diamonds"];
        attach.bounds = CGRectMake(0, -2, 12, 12);
        NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:attach];
        [att appendAttributedString:attrStringWithImage];
        _totalDiamondLabel.attributedText = att;
    }
    return _totalDiamondLabel;
}
- (QMUILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[QMUILabel alloc] init];
        _tipsLabel.backgroundColor = HEX(#F2F3F5);
        _tipsLabel.font = MPFont(10);
        _tipsLabel.textColor = HEX(#999999);
        _tipsLabel.layer.cornerRadius = 5;
        _tipsLabel.layer.masksToBounds = YES;
        _tipsLabel.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 7, 6);
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = @"温馨提示：\n1、预约不可取消，费用暂扣平台\n2、如无法按时赴约，建议私下与对方沟通时间\n3、24h内无回应，或到预约时间末回应，自动退还预约费用";
    }
    return _tipsLabel;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = HEX(#FF6B97);
        [_sureBtn setTitle:Localized(@"确认") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = MPMediumFont(16);
        _sureBtn.layer.cornerRadius = 23;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:Localized(@"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MPFont(16);
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = HEX(#000000).CGColor;
        _cancelBtn.layer.cornerRadius = 23;
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
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
