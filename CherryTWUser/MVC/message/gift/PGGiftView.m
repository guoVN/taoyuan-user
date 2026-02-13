//
//  PGGiftView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/27.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGGiftView.h"
#import "PGGiftCollectionViewCell.h"
#import "PGRechargeListModel.h"

@interface PGGiftView ()<UIGestureRecognizerDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>

@property (nonatomic, strong) PGGiftCollectionViewCell * currentCell;

@end

@implementation PGGiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#2A2A2A, 0.62);
        [self initSubView];
        [self snapSubView];
        [PGUtils getUserInfo];
        if ([PGManager shareModel].giftArray.count==0) {
            [self loadGiftData];
        }else{
            [self updateData:[PGManager shareModel].giftArray];
        }
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.topView];
    [self.topView addSubview:self.topInsideView];
    [self.topView addSubview:self.iconImg];
    [self.topView addSubview:self.diamondLabel];
    [self.topView addSubview:self.sendBtn];
    [self.backView addSubview:self.pagerView];
    [self.backView addSubview:self.pageControl];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.qmui_top = ScreenHeight-SafeBottom-343;
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)snapSubView
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(52);
    }];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(29, 26));
    }];
    [self.diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(1);
        make.centerY.equalTo(self.iconImg.mas_centerY);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.centerY.equalTo(self.iconImg.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(68, 30));
    }];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}
- (void)loadGiftData
{
    WeakSelf(self)
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    [PGAPIService diamondListWithParameters:@{@"packName":@"ntdlaz"} Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        PGRechargeListModel * rechargeModel = [PGRechargeListModel mj_objectWithKeyValues:data[@"data"]];
        [PGManager shareModel].giftArray = [rechargeModel.otherSetting.presentCoins mutableCopy];
        [weakself updateData:rechargeModel.otherSetting.presentCoins];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)updateData:(NSArray *)items
{
    NSMutableArray * resultArray = [NSMutableArray array];
    NSMutableArray * subArray = [NSMutableArray array];
    for (NSInteger i=0; i<items.count; i++) {
        [subArray addObject:items[i]];
        if (subArray.count == 8 || i==items.count-1) {
            [resultArray addObject:subArray];
            subArray = [NSMutableArray array];
        }
    }
    [self.dataArray addObjectsFromArray:resultArray];
    self.pageControl.numberOfPages = self.dataArray.count;
    [self.pageControl setUpDots];
    self.pageControl.center = CGPointMake(SCREEN_WIDTH/2, 332);
    [self.pagerView reloadData];
}
#pragma mark===UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.backView]) {
        return NO;
    }
    return YES;
}
#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.dataArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    PGGiftCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    cell.giftArr = self.dataArray[index];
    cell.index = index;
    
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(ScreenWidth, 343+SafeBottom-52);
    layout.itemSpacing = 0;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.pageControl.currentPage = toIndex;
    self.currentCell = self.pagerView.curIndexCell;
    [self.currentCell refreshGiftChoose:[PGManager shareModel].currentChooseGiftTag];
}

- (void)closeWindow
{
    [PGManager shareModel].currentChooseGiftTag = 0;
    [PGManager shareModel].currentChooseGiftModel = nil;
    [self removeFromSuperview];
}
- (void)sendAction
{
    self.sendBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sendBtn.selected = YES;
    });
    WeakSelf(self)
    [QMUITips showLoadingInView:[PGUtils getCurrentVC].view];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.channelId forKey:@"anchorUserid"];
    [dic setValue:@"" forKey:@"virtualAnchorId"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:[PGManager shareModel].currentChooseGiftModel.name forKey:@"giftType"];
    [dic setValue:@([PGManager shareModel].currentChooseGiftModel.coin) forKey:@"coin"];
    [dic setValue:@"0" forKey:@"callid"];
    [dic setValue:@"ntdlaz" forKey:@"packName"];
    [PGAPIService sendGiftWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [PGManager shareModel].selfCoin -= [PGManager shareModel].currentChooseGiftModel.coin;
        weakself.diamondLabel.text = [NSString stringWithFormat:@"糖币余额：%.0f",[PGManager shareModel].selfCoin*0.1];
        PGTabbarViewController * tabbar = (PGTabbarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        [tabbar showSvga:[PGManager shareModel].currentChooseGiftModel.dynamicPic];
        if (weakself.sendGiftBlock) {
            weakself.sendGiftBlock([PGManager shareModel].currentChooseGiftModel.name);
        }
        [PGManager shareModel].currentChooseGiftTag = 0;
        [PGManager shareModel].currentChooseGiftModel = nil;
        [weakself.currentCell refreshGiftChoose:[PGManager shareModel].currentChooseGiftTag];
        [weakself removeFromSuperview];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
        if ([message containsString:@"金币不足"]) {
            [weakself removeFromSuperview];
            [PGUtils goRechargeAlert];
        }
    }];
}

#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 343+SafeBottom)];
        _backView.backgroundColor = HEX(#151219);
        [_backView acs_radiusWithRadius:18 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _backView;
}
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 52)];
        _topView.backgroundColor = HEX(#312A39);
        [_topView acs_radiusWithRadius:18 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _topView;
}
- (UIView *)topInsideView
{
    if (!_topInsideView) {
        _topInsideView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, ScreenWidth-4, 48)];
        _topInsideView.backgroundColor = HEX(#312A39);
        [_topInsideView acs_radiusWithRadius:18 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
        [_topInsideView addShadowWithColor:HEXAlpha(#C86DAB, 0.7) offset:CGSizeMake(0, 0) radius:4 opacity:0.3];
    }
    return _topInsideView;
}
- (UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc] init];
        [_iconImg setImage:MPImage(@"zuanshi")];
    }
    return _iconImg;
}
- (UILabel *)diamondLabel
{
    if (!_diamondLabel) {
        _diamondLabel = [[UILabel alloc] init];
        _diamondLabel.font = MPBoldFont(16);
        _diamondLabel.textColor = HEX(#FFFFFF);
        _diamondLabel.text = [NSString stringWithFormat:@"糖币余额：%.0f",[PGManager shareModel].selfCoin*0.01];
    }
    return _diamondLabel;
}
- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 30)];
        [_sendBtn yd_setHorizentalGradualFromColor:HEX(#7E68EE) toColor:HEX(#FE7297)];
        [_sendBtn setTitle:@"赠送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightHeavy];
        _sendBtn.layer.cornerRadius = 15;
        _sendBtn.layer.masksToBounds= YES;
        [_sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
- (TYCyclePagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc] init];
        _pagerView.isInfiniteLoop = NO;
        _pagerView.autoScrollInterval = 0;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        [_pagerView registerNib:[UINib nibWithNibName:@"PGGiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    }
    return _pagerView;
}
- (PGPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl  = [[PGPageControl alloc] init];
        _pageControl.currenStyle = Special;
        _pageControl.pageSize = CGSizeMake(6, 6);
        _pageControl.currenPageSize = CGSizeMake(6, 6);
        _pageControl.currenColor = HEX(#FFFFFF);
        _pageControl.defaultColor = HEXAlpha(#FFFFFF, 0.5f);
    }
    return _pageControl;
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
