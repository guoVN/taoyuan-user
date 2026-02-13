//
//  PGChoosePayAlertView.m
//  CherryTWUser
//
//  Created by guo on 2025/11/3.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGChoosePayAlertView.h"
#import "PGChoosePayTableViewCell.h"

@interface PGChoosePayAlertView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGChoosePayAlertView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView*)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        [superView addSubview:self];
        self.backgroundColor = HEX(#FFFFFF);
        [self initSubView];
        [self snapSubView];
    }
    return self;
}
- (void)initSubView
{
    [self acs_radiusWithRadius:20 corner:UIRectCornerTopLeft | UIRectCornerTopRight];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
    [self addSubview:self.sureBtn];
    self.dataArray = [@[@"",@""] mutableCopy];
}
- (void)snapSubView
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.height.mas_equalTo(24);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(-SafeBottom-80);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-SafeBottom-20);
        make.height.mas_equalTo(50);
    }];
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
    PGChoosePayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGChoosePayTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    PGChoosePayTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseImg setImage:MPImage(@"choose_ed")];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGChoosePayTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseImg setImage:MPImage(@"choose_nor")];
}

- (void)sureBtnAction
{
    
}
#pragma mark===懒加载
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPFont(18);
        _titleLabel.textColor = HEX(#000000);
        _titleLabel.text = Localized(@"选择支付方式");
    }
    return _titleLabel;
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGChoosePayTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGChoosePayTableViewCell"];
    }
    return _tableView;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.backgroundColor = HEX(#FF6B97);
        [_sureBtn setTitle:Localized(@"确定") forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(#FFFFFF) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = MPSemiboldFont(20);
        _sureBtn.layer.cornerRadius = 25;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
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
