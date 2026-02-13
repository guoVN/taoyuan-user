//
//  PGPersonalDetailViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPersonalDetailViewController.h"
#import "PGReportViewController.h"
#import "PGChatViewController.h"
//model
#import "PGAnchorModel.h"
#import "PGAnchorTagDataModel.h"
#import "PGYuYueModel.h"
#import "PGYuYueOrderModel.h"
//view
#import "PGPersonalDetailTableHeaderView.h"
#import "PGPersonalMediaTableViewCell.h"
#import "PGPersonalDetailTagTableViewCell.h"
#import "PGPersonalDetailInfoableViewCell.h"
#import "PGPersonalIntroTableViewCell.h"
#import "PGPersonalVideoPriceTableViewCell.h"
#import "PGYuYueTableViewCell.h"
#import "PGCustomAlertView.h"
#import "HMBlackAlertView.h"
#import "PGCallVideoAlertView.h"
#import "PGUnlockChatAlertView.h"

@interface PGPersonalDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) PGPersonalDetailTableHeaderView * tabHeaderView;
@property (weak, nonatomic) IBOutlet QMUIButton *chatBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *videoCalltBtn;
@property (nonatomic, strong) PGAnchorModel * detailModel;
@property (nonatomic, strong) NSArray * anchorTagArray;
@property (nonatomic, assign) BOOL isBlackAnchor;
@property (nonatomic, assign) BOOL isBeBlack;

@property (nonatomic, strong) PGYuYueModel * yuYueModel;
@property (nonatomic, strong) PGYuYueOrderModel * orderModel;

@end

@implementation PGPersonalDetailViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[PGManager shareModel].mainControlAlert closeView];
    [[PGManager shareModel].addProjectlAlert closeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self loadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkBlackStatus];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString * day = [formatter stringFromDate:currentDate];
        [self loadYuYue:day];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkFollowStatus];
    });
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (void)loadUI
{
    self.view.backgroundColor = HEX(#EDEEF2);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(STATUS_H_F);
        make.bottom.mas_equalTo(-SafeBottom-76);
    }];
    [self.view bringSubviewToFront:self.naviView];
    [self.naviView.rightBtn setImage:MPImage(@"more") forState:UIControlStateNormal];
    [self.naviView.rightBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.chatBtn.frame = CGRectMake(0, 0, ScreenWidth-30-13, 50);
    [self.chatBtn yd_setHorizentalGradualFromColor:HEX(#FF6B97) toColor:HEX(#EA5EFB)];
    [self.chatBtn bringSubviewToFront:self.chatBtn.imageView];
}
- (void)loadData
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.anchorid forKey:@"anchorid"];
//    [QMUITips showLoadingInView:self.view];
    [PGAPIService anchorDetailWithParameters:dic Success:^(id  _Nonnull data) {
//        [QMUITips hideAllTips];
        weakself.detailModel = [PGAnchorModel mj_objectWithKeyValues:data[@"data"]];
        weakself.tabHeaderView.detailModel = weakself.detailModel;
        weakself.tabHeaderView.frame = CGRectMake(0, 0, ScreenWidth, [weakself.detailModel.onlineState isEqualToString:@"在线"] ? 175 : 190);
        [weakself.tableView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)loadYuYue:(NSString *)scheduleDate
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.anchorid forKey:@"anchorId"];
    [dic setValue:scheduleDate forKey:@"scheduleDate"];
    [PGAPIService yuYueDetailWithParameters:dic Success:^(id  _Nonnull data) {
    
        weakself.yuYueModel = [PGYuYueModel mj_objectWithKeyValues:data[@"data"]];
        [weakself.tableView reloadData];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)loadTagData
{
    BOOL isHave = NO;
    NSString * tagStr = @"";
    RLMResults *results = [PGAnchorTagDataModel allObjects];
    for (PGAnchorTagDataModel *model in results) {
        if ([model.anchorId integerValue] == self.detailModel.userid) {
            tagStr = model.tagStr;
            self.anchorTagArray = [tagStr componentsSeparatedByString:@","];
            isHave = YES;
            break;
        }
    }
    if (!isHave) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"anchorTag" ofType:@"txt"];
        NSData * content=[NSData dataWithContentsOfFile:path];
        NSString * string = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
        self.anchorTagArray = [PGUtils jsonToObject:string];
        NSInteger radom = arc4random_uniform(100) + 1;
        if (radom <=60) {
            self.anchorTagArray = [PGUtils randomArray:self.anchorTagArray byLength:4];
        }else if (radom <= 80){
            self.anchorTagArray = [PGUtils randomArray:self.anchorTagArray byLength:2];
        }else{
            self.anchorTagArray = [PGUtils randomArray:self.anchorTagArray byLength:3];
        }
        tagStr = [self.anchorTagArray componentsJoinedByString:@","];
        RLMRealm *realm = [RLMRealm defaultRealm];
        PGAnchorTagDataModel * model = [[PGAnchorTagDataModel alloc] init];
        model.anchorId = [NSString stringWithFormat:@"%ld",self.detailModel.userid];
        model.tagStr = tagStr;
        [realm transactionWithBlock:^{
            [realm addObject:model];
        }];
    }
}

- (void)checkFollowStatus
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.anchorid forKey:@"friendid"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService checkCollectStatusWithParameters:dic Success:^(id  _Nonnull data) {
      
        weakself.tabHeaderView.isFollow = [data[@"data"] integerValue];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}

- (void)checkBlackStatus
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"senderId"];
    [dic setValue:self.anchorid forKey:@"recipientId"];
    [PGAPIService checkBlackenedWithParameters:dic Success:^(id  _Nonnull data) {
        NSDictionary * dataDic = data[@"data"];
        weakself.isBlackAnchor = [dataDic[@"senderBlockRecipient"] boolValue];
        weakself.isBeBlack = [dataDic[@"recipientBlockSender"] boolValue];
        if (weakself.isBlackAnchor) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:@"已拉黑，您将收不到她的任何消息"];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
    }];
}
- (void)blackAnchorAction
{
    WeakSelf(self)
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonZoomInCombin)
        .wHideAnimationSet(AninatonZoomOut)
        .wShadowCanTapSet(YES)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMBlackAlertView *view = [[HMBlackAlertView alloc] initWithFrame:CGRectMake(0, 0, 305, 156) superView:mainView];
                view.sureBlock = ^{
                    [weakself doBlackAnchorAction];
                };
                return view;
            })
        .wStart();
}
- (void)doBlackAnchorAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.anchorid forKey:@"targetid"];
    [dic setValue:@"1" forKey:@"isMultiple"];
    [PGAPIService blackAddWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips showWithText:@"拉黑成功"];
        weakself.isBlackAnchor = YES;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showWithText:message];
    }];
}
- (void)cancelBlackAnchorAction
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.anchorid forKey:@"targetid"];
    [PGAPIService cancelBlackActionWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips showWithText:@"取消拉黑成功"];
        weakself.isBlackAnchor = NO;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showWithText:message];
    }];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 3 && self.detailModel.femaleAdditionalConfigList.count == 0 && self.detailModel.customSign.length == 0) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(self)
    if (indexPath.section == 0) {
        PGPersonalDetailInfoableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGPersonalDetailInfoableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        [cell layoutIfNeeded];
        return cell;
    }else if (indexPath.section == 1){
        PGPersonalIntroTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGPersonalIntroTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        [cell layoutIfNeeded];
        return cell;
    }else if (indexPath.section == 2){
        PGPersonalVideoPriceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGPersonalVideoPriceTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        [cell layoutIfNeeded];
        return cell;
    }else if (indexPath.section == 3){
        PGPersonalDetailTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGPersonalDetailTagTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        [cell layoutIfNeeded];
        return cell;
    }else if(indexPath.section == 4){
        PGPersonalMediaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGPersonalMediaTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        [cell layoutIfNeeded];
        return cell;
    }else{
        PGYuYueTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGYuYueTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailModel = self.detailModel;
        cell.yuYueModel = self.yuYueModel;
        cell.changeDayBlock = ^(NSString * _Nonnull scheduleDate) {
            [weakself loadYuYue:scheduleDate];
        };
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
    return 10;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat navAlpha = scrollView.contentOffset.y/(STATUS_H_F+44);
    self.naviView.backgroundColor = HEXAlpha(#FFFFFF, navAlpha);
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 当手势是侧滑返回手势时，禁止触发
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer && self.isFromChat) {
        return NO;
    }
    return YES;
}
- (void)moreBtnAction
{
    WeakSelf(self)
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog().wTypeSet(DialogTypePop)
    //点击事件
    .wEventFinishSet(^(id anyID, NSIndexPath *path, DialogType type) {
        NSLog(@"%@ %@",anyID,path);
        [weakself moreAction:anyID];
    })
    
    //下划线显示
    .wSeparatorStyleSet(UITableViewCellSeparatorStyleSingleLine)
    //可以设置三角形的颜色
    .wMainBackColorSet([UIColor clearColor])
    //距离弹出点的距离
    .wMainOffsetYSet(-10)
    //导航栏上
    .wTapViewTypeSet(DiaPopInViewNavi)
    //弹出动画
    .wShowAnimationSet(AninatonZoomIn)
    //消失动画
    .wHideAnimationSet(AninatonZoomOut)
    //全部圆角 用法和系统的UIRectCorner相同
    .wPopViewRectCornerSet(DialogRectCornerAllCorners)
    .wWidthSet(80)
    .wHeightSet(69)
    //弹窗位置
    .wDirectionSet(directionDowm)
    ///改变对齐方向
    .wCellAlignTypeSet(DialogCellAlignCenter)
    //数据
    .wDataSet(@[self.isBlackAnchor == YES ? Localized(@"解除拉黑") : Localized(@"拉黑"),Localized(@"举报")])
    //弹出视图
    .wTapViewSet(self.naviView.rightBtn)
    .wStart();
}
- (void)moreAction:(id)str
{
    if ([str isEqualToString:Localized(@"拉黑")]){
        [self blackAnchorAction];
    }else if ([str isEqualToString:Localized(@"举报")]){
        PGReportViewController * vc = [[PGReportViewController alloc] init];
        vc.anchorId = [NSString stringWithFormat:@"%ld",self.detailModel.userid];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([str isEqualToString:Localized(@"解除拉黑")]){
        [self cancelBlackAnchorAction];
    }
}
- (IBAction)chatBtnAction:(id)sender {
    if (self.isBlackAnchor) {
        [QMUITips showWithText:@"已拉黑，您将收不到她的任何消息"];
        return;
    }
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.channelId = [NSString stringWithFormat:@"%ld",self.detailModel.userid];
    vc.friendHead = self.detailModel.photo;
    vc.friendName = self.detailModel.nickName;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)videoCallBtnAction:(id)sender {
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.detailModel.userid) forKey:@"anchorId"];
    [dic setValue:@"" forKey:@"virtualAnchorId"];
    [dic setValue:@"2" forKey:@"type"];
    [dic setValue:@"0" forKey:@"userReserveOrder"];
    [dic setValue:@"" forKey:@"consumeCoin"];
    [PGAPIService videoCheckPreChargingWithParameters:dic Success:^(id  _Nonnull data) {
        BOOL isHaveYuyueOrder = [data[@"data"] boolValue];
        [weakself judgeHaveYuYueOrder:isHaveYuyueOrder];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)judgeHaveYuYueOrder:(BOOL)isHaveYuyueOrder
{
    WeakSelf(self)
    if (isHaveYuyueOrder) {
        [self loadNoUseOrder];
    }else{
        [[PGManager shareModel].mainControlAlert closeView];
        [PGManager shareModel].mainControlAlert = Dialog()
            .wLevelSet(999)
            .wTagSet(random()%100000)
            .wTypeSet(DialogTypeMyView)
            .wShowAnimationSet(AninatonZoomInCombin)
            .wHideAnimationSet(AninatonZoomOut)
            .wShadowCanTapSet(YES)
            .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
                mainView.backgroundColor = [UIColor clearColor];
                PGCallVideoAlertView *view = [[PGCallVideoAlertView alloc] initWithFrame:CGRectMake(0, 0, 305, 329) superView:mainView];
                    view.detailModel = weakself.detailModel;
                    return view;
                })
            .wStart();
    }
}
- (void)loadNoUseOrder
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(self.detailModel.userid) forKey:@"anchorId"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userId"];
    [PGAPIService checkNoUseYuYueOrderWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.orderModel = [PGYuYueOrderModel mj_objectWithKeyValues:data[@"data"]];
        if (weakself.orderModel != nil) {
            [weakself showJudgechooseCallType];
        }else{
            [weakself judgeHaveYuYueOrder:NO];
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)showJudgechooseCallType
{
    WeakSelf(self)
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonZoomInCombin)
        .wHideAnimationSet(AninatonZoomOut)
        .wShadowCanTapSet(YES)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            PGUnlockChatAlertView *view = [[PGUnlockChatAlertView alloc] initWithFrame:CGRectMake(0, 0, 305, 160) superView:mainView];
                view.type = 2;
                view.sureBlock = ^{
                    
                };
                view.cancelBlock = ^{
                    [weakself judgeHaveYuYueOrder:NO];
                };
                return view;
            })
        .wStart();
}
- (IBAction)collectBtnAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.anchorid forKey:@"friendid"];
    if (sender.selected) {
        [PGAPIService collectAddWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips showWithText:data[@"msg"]];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            sender.selected = NO;
            [QMUITips showWithText:message];
        }];
    }else{
        [PGAPIService collectCancelWithParameters:dic Success:^(id  _Nonnull data) {
            [QMUITips showWithText:data[@"msg"]];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            sender.selected = YES;
            [QMUITips showWithText:message];
        }];
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGPersonalMediaTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGPersonalMediaTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGPersonalDetailTagTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGPersonalDetailTagTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGPersonalDetailInfoableViewCell" bundle:nil] forCellReuseIdentifier:@"PGPersonalDetailInfoableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGYuYueTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGYuYueTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGPersonalIntroTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGPersonalIntroTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGPersonalVideoPriceTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGPersonalVideoPriceTableViewCell"];
        _tableView.tableHeaderView = self.tabHeaderView;
    }
    return _tableView;
}
- (PGPersonalDetailTableHeaderView *)tabHeaderView
{
    if (!_tabHeaderView) {
        _tabHeaderView = [[PGPersonalDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 175)];
    }
    return _tabHeaderView;
}
- (NSArray *)anchorTagArray
{
    if (!_anchorTagArray) {
        _anchorTagArray = [NSArray array];
    }
    return _anchorTagArray;
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
