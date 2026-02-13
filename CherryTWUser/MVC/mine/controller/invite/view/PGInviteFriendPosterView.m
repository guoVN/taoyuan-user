//
//  PGInviteFriendPosterView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/9.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGInviteFriendPosterView.h"
#import "PGInviteFriendPosterCollectionViewCell.h"

@interface PGInviteFriendPosterView()<UIGestureRecognizerDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>

@property (nonatomic, strong) PGInviteFriendPosterCollectionViewCell * currentCell;

@end

@implementation PGInviteFriendPosterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#2A2A2A, 0.78f);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.pagerView];
    [self.backView addSubview:self.pageControl];
    [self.backView addSubview:self.saveBtn];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWindow)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.dataArray = @[@"poster1",@"poster2",@"poster3",@"poster4"];
    self.pageControl.numberOfPages = self.dataArray.count;
    [self.pageControl setUpDots];
    self.pageControl.center = CGPointMake(SCREEN_WIDTH/2, 332);
    [self.pagerView reloadData];
}
- (void)snapSubView
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.mas_equalTo(0);
        make.height.mas_equalTo(501);
    }];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(37);
        make.height.mas_equalTo(266);
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-78);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(189, 46));
    }];
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
    PGInviteFriendPosterCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    [cell.backImg setImage:MPImage(self.dataArray[index])];
    cell.codeStr = self.inviteCode;
    cell.linkUrl = self.linkUrl;
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(213, 266);
    layout.itemSpacing = 18;
    //layout.minimumAlpha = 0.3;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.pageControl.currentPage = toIndex;
}

- (void)closeWindow
{
    [self removeFromSuperview];
}
- (void)saveBtnAction
{
    self.currentCell = self.pagerView.curIndexCell;
    [PGUtils saveImgWithView:self.currentCell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
#pragma mark===懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UUWhite;
        [_backView acs_radiusWithRadius:10 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _backView;
}
- (TYCyclePagerView *)pagerView
{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc] init];
        _pagerView.isInfiniteLoop = YES;
        _pagerView.autoScrollInterval = 0;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        [_pagerView registerNib:[UINib nibWithNibName:@"PGInviteFriendPosterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    }
    return _pagerView;
}
- (PGPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl  = [[PGPageControl alloc] init];
        _pageControl.currenStyle = Special;
        _pageControl.pageSize = CGSizeMake(9, 9);
        _pageControl.currenPageSize = CGSizeMake(9, 9);
        _pageControl.currenColor = HEX(#777777);
        _pageControl.defaultColor = HEX(#F1F1F1);
    }
    return _pageControl;
}
- (QMUIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [[QMUIButton alloc] init];
        _saveBtn.backgroundColor = HEX(#FD87B2);
        _saveBtn.imagePosition = QMUIButtonImagePositionLeft;
        _saveBtn.spacingBetweenImageAndTitle = 4;
        [_saveBtn setImage:MPImage(@"icon_save") forState:UIControlStateNormal];
        [_saveBtn setTitle:@"保存到本地" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:UUWhite forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = MPBoldFont(20);
        _saveBtn.layer.cornerRadius = 23;
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
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
