//
//  PGMineViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#import "PGMineViewController.h"
#import "PGEditInfoViewController.h"
#import "PGMyAlbumViewController.h"
#import "PGSetViewController.h"
#import "PGDiamondsListViewController.h"
#import "PGInviteFriendViewController.h"
#import "PGMyCollectViewController.h"
#import "PGMyDynamicViewController.h"
#import "PGWebViewController.h"
#import "PGWithdrawalViewController.h"
#import "PGNoticeViewController.h"
#import "PGFollowAndFansViewController.h"
#import "PGYuYueRecordViewController.h"
//view
#import "PGMineTableViewCell.h"
#import "PGRechargeAlertView.h"

@interface PGMineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;
@property (weak, nonatomic) IBOutlet UIView *noticeRedView;
@property (nonatomic, strong) QMUIButton * fansBtn;
@property (nonatomic, strong) QMUIButton * followBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *editBtn;

@end

@implementation PGMineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [PGUtils getUserInfo];
    [self loadData];
    [self loadFansAndFollow];
    
//    WeakSelf(self)
//    [[PGManager shareModel].mainControlAlert closeView];
//    [PGManager shareModel].mainControlAlert = Dialog()
//        .wLevelSet(999)
//        .wTagSet(random()%100000)
//        .wTypeSet(DialogTypeMyView)
//        .wShowAnimationSet(AninatonCurverOn)
//        .wHideAnimationSet(AninatonCurverOff)
//        .wPointSet(CGPointMake(0, ScreenHeight-429-SafeBottom))
//        .wShadowCanTapSet(YES)
//        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
//            mainView.backgroundColor = [UIColor clearColor];
//            PGRechargeAlertView *view = [[PGRechargeAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 429+SafeBottom) superView:mainView];
//                
//                return view;
//            })
//        .wStart();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"UpdateUserInfo" object:nil];
}
- (void)loadUI
{
    self.naviView.alpha = 0;
    self.view.backgroundColor = HEX(#EDEEF2);
    [self.view addSubview:self.followBtn];
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-ScreenWidth*0.25);
        make.top.equalTo(self.headImg.mas_bottom).offset(20);
    }];
    [self.view addSubview:self.fansBtn];
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ScreenWidth*0.25);
        make.centerY.equalTo(self.followBtn.mas_centerY);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.editBtn.mas_bottom).offset(113);
        make.bottom.mas_equalTo(-SafeBottom-49);
    }];
}
- (void)loadData
{
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[PGManager shareModel].userInfo.photo]];
    self.nameLabel.text = [PGManager shareModel].userInfo.nickName;
    self.IDLabel.text = [NSString stringWithFormat:@"ID：%@",[PGManager shareModel].userInfo.userid];
    self.dataArray = [@[@{@"img":@"icon_recharge",@"name":@"充值"},
                        @{@"img":@"icon_yuyue",@"name":@"预约"},
                        @{@"img":@"icon_service",@"name":@"客服"},
                        @{@"img":@"icon_invite",@"name":@"邀请好友"},
                        @{@"img":@"icon_set",@"name":@"设置"}] mutableCopy];
    [self.tableView reloadData];
}
- (void)loadFansAndFollow
{
    WeakSelf(self)
    [PGAPIService fansAndFollowNumWithParameters:@{@"userid":[PGManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
        [weakself dealAttentionAndFans:data[@"data"]];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)dealAttentionAndFans:(NSDictionary *)dic
{
    NSString * fansStr = [NSString stringWithFormat:@"%@\n%@",Localized(@"粉丝"),dic[@"fansNum"]];
    NSMutableAttributedString * fansAtt = [[NSMutableAttributedString alloc] initWithString:fansStr];
    NSRange fansRange = [fansStr rangeOfString:Localized(@"粉丝")];
    [fansAtt addAttributes:@{NSFontAttributeName:MPFont(14),NSForegroundColorAttributeName:HEX(#999999)} range:fansRange];
    NSMutableParagraphStyle * fansPara = [[NSMutableParagraphStyle alloc] init];
    fansPara.lineSpacing = 4;
    fansPara.alignment = NSTextAlignmentCenter;
    [fansAtt addAttribute:NSParagraphStyleAttributeName value:fansPara range:NSMakeRange(0, fansStr.length)];
    [self.fansBtn setAttributedTitle:fansAtt forState:UIControlStateNormal];
    
    NSString * followStr = [NSString stringWithFormat:@"%@\n%@",Localized(@"关注"),dic[@"attentionNum"]];
    NSMutableAttributedString * followAtt = [[NSMutableAttributedString alloc] initWithString:followStr];
    NSRange followRange = [followStr rangeOfString:Localized(@"关注")];
    [followAtt addAttributes:@{NSFontAttributeName:MPFont(14),NSForegroundColorAttributeName:HEX(#999999)} range:followRange];
    NSMutableParagraphStyle * followPara = [[NSMutableParagraphStyle alloc] init];
    followPara.lineSpacing = 4;
    followPara.alignment = NSTextAlignmentCenter;
    [followAtt addAttribute:NSParagraphStyleAttributeName value:followPara range:NSMakeRange(0, followStr.length)];
    [self.followBtn setAttributedTitle:followAtt forState:UIControlStateNormal];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return self.dataArray.count-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGMineTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGMineTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic = self.dataArray[indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell acs_radiusWithRadius:20 corner:UIRectCornerTopLeft|UIRectCornerTopRight];
        }else if (indexPath.row == self.dataArray.count-2){
            [cell acs_radiusWithRadius:20 corner:UIRectCornerBottomLeft|UIRectCornerBottomRight];
        }else{
            [cell acs_radiusWithRadius:0 corner:UIRectCornerAllCorners];
        }
    }else{
        dic = self.dataArray.lastObject;
        [cell acs_radiusWithRadius:20 corner:UIRectCornerAllCorners];
    }
    [cell.iconImg setImage:MPImage(dic[@"img"]]);
    cell.titleLabel.text = dic[@"name"];
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
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
    NSDictionary * dic = self.dataArray[indexPath.row];
    if (indexPath.section == 1) {
        dic = self.dataArray.lastObject;
    }
    NSString * titleStr = dic[@"name"];
    if ([titleStr isEqualToString:@"充值"]){
        PGDiamondsListViewController * vc = [[PGDiamondsListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleStr isEqualToString:@"预约"]){
        PGYuYueRecordViewController * vc = [[PGYuYueRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleStr isEqualToString:@"客服"]){
        PGWebViewController * vc = [PGWebViewController controllerWithTitle:@"客服" url:[PGManager shareModel].searviceLinkStr];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleStr isEqualToString:@"邀请好友"]) {
        PGInviteFriendViewController * vc = [[PGInviteFriendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleStr isEqualToString:@"设置"]){
        PGSetViewController * vc = [[PGSetViewController alloc] init];
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGMineTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGMineTableViewCell"];
    }
    return _tableView;
}
- (QMUIButton *)fansBtn
{
    if (!_fansBtn) {
        _fansBtn = [[QMUIButton alloc] init];
        _fansBtn.imagePosition = QMUIButtonImagePositionLeft;
        _fansBtn.spacingBetweenImageAndTitle = 5;
//        [_fansBtn setImage:MPImage(@"fansIcon") forState:UIControlStateNormal];
        [_fansBtn setTitle:[NSString stringWithFormat:@"%@：0",Localized(@"粉丝")] forState:UIControlStateNormal];
        [_fansBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _fansBtn.titleLabel.font = MPBoldFont(20);
        _fansBtn.titleLabel.numberOfLines = 0;
        _fansBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _fansBtn.tag = 100;
        [_fansBtn addTarget:self action:@selector(userListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fansBtn;
}
- (QMUIButton *)followBtn
{
    if (!_followBtn) {
        _followBtn = [[QMUIButton alloc] init];
        _followBtn.imagePosition = QMUIButtonImagePositionLeft;
        _followBtn.spacingBetweenImageAndTitle = 5;
//        [_followBtn setImage:MPImage(@"followIcon") forState:UIControlStateNormal];
        [_followBtn setTitle:[NSString stringWithFormat:@"%@：0",Localized(@"关注")] forState:UIControlStateNormal];
        [_followBtn setTitleColor:HEX(#000000) forState:UIControlStateNormal];
        _followBtn.titleLabel.font = MPBoldFont(20);
        _followBtn.titleLabel.numberOfLines = 0;
        _followBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _followBtn.tag = 200;
        [_followBtn addTarget:self action:@selector(userListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}
- (IBAction)copyIdAction:(id)sender {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = [PGManager shareModel].userInfo.userid;
    [QMUITips showWithText:@"已复制"];
}
- (IBAction)editInfoAction:(id)sender {
    PGEditInfoViewController * vc = [[PGEditInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)goRechargeAction:(id)sender {
    PGDiamondsListViewController * vc = [[PGDiamondsListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)noticeBtnAction:(id)sender {
    PGNoticeViewController * vc = [[PGNoticeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)userListAction:(QMUIButton *)sender
{
    PGFollowAndFansViewController * vc = [[PGFollowAndFansViewController alloc] init];
    vc.type = sender.tag == 200 ? 0 : 1;
    [self.navigationController pushViewController:vc animated:YES];
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
