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
                            @{@"name":Localized(@"ID"),@"desc":@"ID：666666"},] mutableCopy];
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
        }else if (indexPath.row == 1){
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
    }else if(indexPath.section == 1 && indexPath.row == 0){
        PGEditNicknameViewController * vc = [[PGEditNicknameViewController alloc] init];
        vc.type = 1;
        vc.contentStr = [PGManager shareModel].userInfo.nickName;
        vc.updateBlock = ^(NSString * _Nonnull result) {
            [PGManager shareModel].userInfo.nickName = result;
            [weakself.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
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
