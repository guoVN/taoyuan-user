//
//  PGPickerView.m
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPickerView.h"

@interface PGPickerView ()<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, copy) NSString * choosePickStr;
@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIView * bottomLine;

@end

@implementation PGPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXAlpha(#000000, 0.7f);
        [self initSubView];
        [self snapSubview];
    }
    return self;
}
- (void)initSubView
{
    [self addSubview:self.menuView];
    [self.menuView addSubview:self.titleLabel];
    [self.menuView addSubview:self.pickView];
    [self.menuView addSubview:self.cancelBtn];
    [self.menuView addSubview:self.sureBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.menuView.qmui_top = ScreenHeight-256-SafeBottom;
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBack)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
- (void)snapSubview
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
    }];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(180);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(60, 49));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(60, 49));
    }];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.pickView selectRow:1 inComponent:0 animated:YES];
    self.choosePickStr = dataArray[1];
}

- (UIView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 256+SafeBottom)];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.layer.cornerRadius = 15;
        _menuView.layer.masksToBounds = YES;
        [_menuView acs_radiusWithRadius:30 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _menuView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = MPBoldFont(24);
        _titleLabel.textColor = HEX(#000000);
    }
    return _titleLabel;
}
- (UIPickerView *)pickView
{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.backgroundColor=[UIColor clearColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.showsSelectionIndicator = YES;
    }
    return _pickView;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEX(#999999) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [_cancelBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:THEAME_COLOR forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
#pragma mark===UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.menuView]) {
        return NO;
    }
    return YES;
}
- (void)clickBack
{
    [self removeFromSuperview];
}
- (void)sureBtnAction
{
    if (self.choosePickBlock) {
        self.choosePickBlock(self.choosePickStr);
    }
    [self clickBack];
}
#pragma mark =====UIPickerViewDataSource,UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

#pragma mark ===== 显示内容
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataArray[row];
}

#pragma mark ===== 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

#pragma mark ===== 行高

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 63;
}

#pragma mark ===== 返回选中的行

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str=self.dataArray[row]; //输出的结果
    self.choosePickStr = str;
}

#pragma mark ===== 自定义显示的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textColor= HEX(#333333);
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
    }
    
    //背景色
    [self changePickViewSelectCustom];
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
        singleLine.backgroundColor = HEX(#EEEEEE);
        }
    }
    
    if (self.subviews.count > 0) {
        //subviews[0]是选中行后面那一层,subviews[1]是选中行
        pickerView.subviews[1].backgroundColor = [UIColor clearColor];// 去除原本的灰色背景
        //添加分割线
        if (!_topLine) {//防止重复创建
            _topLine = [UILabel new];
            [pickerView.subviews[1] addSubview:_topLine];
            [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
            _topLine.backgroundColor = HEX(#EEEEEE);//分割线颜色
        }
        
        if(!_bottomLine) {
            _bottomLine = [UILabel new];
            [pickerView.subviews[1] addSubview:_bottomLine];
            [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
            _bottomLine.backgroundColor =HEX(#EEEEEE);
        }
    }

    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)changePickViewSelectCustom
{
    NSArray *subviews = self.pickView.subviews;
    if (!(subviews.count > 0)) {
        return;
    }

    NSArray *coloms = subviews.firstObject;
    if (coloms) {
        NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
        if (subviewCache.count > 0) {
            UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
            if (middleContainerView) {
                middleContainerView.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
