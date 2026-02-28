//
//  PGEditInfoViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGEditInfoViewController.h"
#import "PGEditNicknameViewController.h"
//view
#import "HMPersonalInfoEditHeadTableViewCell.h"
#import "HMPersonalInfoEditInfoTableViewCell.h"
#import "PGPickerView.h"

@interface PGEditInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * headArray;
@property (nonatomic, strong) NSMutableArray * nickArray;

@property (nonatomic, strong) NSMutableArray * ageArray;
@property (nonatomic, strong) NSMutableArray * tallArray;
@property (nonatomic, strong) NSMutableArray * weightArray;
@property (nonatomic, strong) NSMutableArray * socialArray;
@property (nonatomic, copy) NSString * ageStr;
@property (nonatomic, copy) NSString * tallStr;
@property (nonatomic, copy) NSString * weightStr;
@property (nonatomic, copy) NSString * socialStr;
@property (nonatomic, assign) BOOL isSetAge;
@property (nonatomic, assign) BOOL isSetTall;
@property (nonatomic, assign) BOOL isSetWeight;
@property (nonatomic, assign) BOOL isSetSocial;

@end

@implementation PGEditInfoViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [PGUtils getUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.titleStr = @"编辑资料";
    self.view.backgroundColor = HEX(#EDEEF2);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(STATUS_H_F+44+10);
        make.bottom.mas_equalTo(0);
    }];
    self.headArray = [@[@{@"name":Localized(@"头像"),@"desc":@""}] mutableCopy];
    self.nickArray = [@[@{@"name":Localized(@"昵称"),@"desc":@"Video003"},
                        @{@"name":Localized(@"ID"),@"desc":@"ID：666666"},
                        @{@"name":Localized(@"个性签名"),@"desc":@"666666"},
                        @{@"name":Localized(@"性别"),@"desc":@"未设置"},
                        @{@"name":Localized(@"年龄"),@"desc":@"18"},
                        @{@"name":Localized(@"身高"),@"desc":@"160cm"},
                        @{@"name":Localized(@"体重"),@"desc":@"50kg"},
                        @{@"name":Localized(@"情感状态"),@"desc":@"单身"},] mutableCopy];
    
    self.ageArray = [NSMutableArray array];
    for (NSInteger i=18; i<60; i++) {
        [self.ageArray addObject:[NSString stringWithFormat:@"%ld岁",i]];
    }
    self.tallArray = [NSMutableArray array];
    for (NSInteger i=150; i<189; i++) {
        [self.tallArray addObject:[NSString stringWithFormat:@"%ldcm",i]];
    }
    self.weightArray = [NSMutableArray array];
    for (NSInteger i=40; i<150; i++) {
        [self.weightArray addObject:[NSString stringWithFormat:@"%ldkg",i]];
    }
    self.socialArray = [@[@"离异",@"单身",@"寻找知己"] mutableCopy];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.headArray.count;
    }else if (section == 1){
        return self.nickArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        return 66;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HMPersonalInfoEditHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HMPersonalInfoEditHeadTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell layoutIfNeeded];
        return cell;
    }else{
        HMPersonalInfoEditInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HMPersonalInfoEditInfoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary * dic = self.nickArray[indexPath.row];
        cell.titleLabel.text = dic[@"name"];
        cell.indexPath = indexPath;
        if (indexPath.row == 0) {
            [cell acs_radiusWithRadius:15 corner:UIRectCornerTopLeft | UIRectCornerTopRight];
        }else if (indexPath.row == self.nickArray.count-1){
            cell.lineView.alpha = 0;
            [cell acs_radiusWithRadius:15 corner:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        }
        [cell layoutIfNeeded];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
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
    WeakSelf(self)
    if (indexPath.section == 0) {
        HMPersonalInfoEditHeadTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell headImgClick];
    }else if(indexPath.section == 1){
        NSString * titleStr = self.nickArray[indexPath.row][@"name"];
        if ([titleStr isEqualToString:Localized(@"昵称")]) {
            PGEditNicknameViewController * vc = [[PGEditNicknameViewController alloc] init];
            vc.type = 1;
            vc.contentStr = [PGManager shareModel].userInfo.nickName;
            vc.updateBlock = ^(NSString * _Nonnull result) {
                [PGManager shareModel].userInfo.nickName = result;
                [weakself.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:Localized(@"个性签名")]){
            PGEditNicknameViewController * vc = [[PGEditNicknameViewController alloc] init];
            vc.type = 2;
            vc.contentStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"signStr"];
            vc.updateBlock = ^(NSString * _Nonnull result) {
                [PGManager shareModel].userInfo.nickName = result;
                [weakself.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([titleStr isEqualToString:Localized(@"年龄")]){
            [self chooseAgeOrTall:1];
        }else if ([titleStr isEqualToString:Localized(@"身高")]){
            [self chooseAgeOrTall:2];
        }else if ([titleStr isEqualToString:Localized(@"体重")]){
            [self chooseAgeOrTall:3];
        }else if ([titleStr isEqualToString:Localized(@"情感状态")]){
            [self chooseAgeOrTall:4];
        }
        
    }
}

- (void)chooseAgeOrTall:(NSInteger)type
{
    WeakSelf(self)
    id firstObjc;
    NSArray * dataArr;
    if (type == 1) {
        firstObjc = self.ageArray.firstObject;
        dataArr = self.ageArray;
    }else if (type == 2){
        firstObjc = self.tallArray.firstObject;
        dataArr = self.tallArray;
    }else if (type == 3){
        firstObjc = self.weightArray.firstObject;
        dataArr = self.weightArray;
    }else if (type == 4){
        firstObjc = self.socialArray.firstObject;
        dataArr = self.socialArray;
    }
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
   .wTypeSet(DialogTypePickSelect)
   .wEventOKFinishSet(^(id anyID, id otherData) {
          NSLog(@"%@",anyID);
       if (type == 1) {
           weakself.ageStr = [anyID stringByReplacingOccurrencesOfString:@"岁" withString:@""];
           [weakself setAgeAction];
       }else if(type == 2){
           weakself.tallStr = [anyID stringByReplacingOccurrencesOfString:@"cm" withString:@""];
           [weakself setTallAction];
       }else if(type == 3){
           weakself.weightStr = [anyID stringByReplacingOccurrencesOfString:@"kg" withString:@""];
           [weakself setWeightAction];
       }else if(type == 4){
           weakself.socialStr = anyID;
           [weakself setSocialAction];
       }
    })
   .wCancelTitleSet(Localized(@"取消"))
   .wOKTitleSet(Localized(@"确定"))
   .wOKColorSet(HEX(#A0A0EB))
   .wListDefaultValueSet(@[firstObjc])  //默认
   //一层直接传入带字典/字符串的数组 name为显示的文字 其他携带的model可以自由传入
   .wDataSet(dataArr)
   .wStart();
}
- (void)setAgeAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.ageStr forKey:@"age"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService updateAgeWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.isSetAge = YES;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)setTallAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.tallStr forKey:@"height"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService updateTallWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.isSetTall = YES;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)setWeightAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.weightStr forKey:@"weight"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService updateWeightWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.isSetTall = YES;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)setSocialAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.socialStr forKey:@"emotionState"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService updateEmotionStateWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        weakself.isSetTall = YES;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}

#pragma mark-======创建表视图
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
        [_tableView registerNib:[UINib nibWithNibName:@"HMPersonalInfoEditHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMPersonalInfoEditHeadTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HMPersonalInfoEditInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMPersonalInfoEditInfoTableViewCell"];
    }
    return _tableView;
}
- (NSMutableArray *)headArray
{
    if (!_headArray) {
        _headArray = [NSMutableArray array];
    }
    return _headArray;
}
- (NSMutableArray *)nickArray
{
    if (!_nickArray) {
        _nickArray = [NSMutableArray array];
    }
    return _nickArray;
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
