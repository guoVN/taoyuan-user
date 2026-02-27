//
//  PGMessageListViewController.m
//  CherryTWUser
//
//  Created by guo on 2026/2/27.
//  Copyright © 2026 guo. All rights reserved.
//

#import "PGMessageListViewController.h"
#import "PGMessageSystemViewController.h"
#import "PGChatViewController.h"
#import "PGWebViewController.h"
#import "PGContainerVC.h"
#import "PGNavigationViewController.h"
//model
#import "PGMessageListModel.h"
#import "HMIntimacyListModel.h"
//view
#import "HMMsgTableViewCell.h"
#import "HMQinmiTableViewCell.h"

@interface PGMessageListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSDictionary * imOnlineDic;
@property (nonatomic, strong) NSDictionary * qinmiOnlineDic;

@end

@implementation PGMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}
- (void)loadUI
{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)setImResultArr:(NSMutableArray *)imResultArr
{
    _imResultArr = imResultArr;
    if (self.index == 0 && imResultArr.count>0) {
        NSMutableArray * userIdArr = [NSMutableArray array];
        for (AgoraChatConversation * imModel in imResultArr) {
            [userIdArr addObject:[NSString stringWithFormat:@"%@",imModel.conversationId]];
        }
//        WeakSelf(self)
//        [PGAPIService checkUserOnlineStateWithParameters:@{@"userIds":userIdArr} Success:^(id  _Nonnull data) {
//            weakself.imOnlineDic = data[@"data"];
//            [weakself.tableView reloadData];
//        } failure:^(NSInteger code, NSString * _Nonnull message) {
//            
//        }];
    }
}
- (void)setQinmiDataArray:(NSMutableArray *)qinmiDataArray
{
    _qinmiDataArray = qinmiDataArray;
    if (self.index == 1 && qinmiDataArray.count>0) {
        NSMutableArray * userIdArr = [NSMutableArray array];
        for (HMIntimacyListModel * model in qinmiDataArray) {
            [userIdArr addObject:[NSString stringWithFormat:@"%@",model.userid]];
        }
//        WeakSelf(self)
//        [PGAPIService checkUserOnlineStateWithParameters:@{@"userIds":userIdArr} Success:^(id  _Nonnull data) {
//            weakself.qinmiOnlineDic = data[@"data"];
//            [weakself.tableView reloadData];
//        } failure:^(NSInteger code, NSString * _Nonnull message) {
//            
//        }];
    }
    
}
- (void)loadData
{
   /* WeakSelf(self)
    if (self.index == 0) {
        NSArray <AgoraChatConversation *>*conversations = [AgoraChatClient.sharedClient.chatManager getAllConversations:YES];
        self.dataArray = [NSMutableArray arrayWithArray:conversations];
        [self.tableView reloadData];
        NSInteger unreadCount = 0;
        for (AgoraChatConversation *conversation in conversations) {
            unreadCount += conversation.unreadMessagesCount;
        }
        self.tabBarController.tabBar.items[2].badgeValue = [NSString stringWithFormat:@"%ld",unreadCount];
        if (unreadCount == 0) {
            self.tabBarController.tabBar.items[2].badgeValue = nil;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
    }else{
        [HMNetService intimacyListWithParameters:@{@"userId":[HMManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
            NSArray * items = [HMIntimacyListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            weakself.dataArray = [NSMutableArray arrayWithArray:items];
            [weakself.tableView reloadData];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips showWithText:message];
        }];
    }*/
}

- (UIView *)listView
{
    return self.view;
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.index == 0) {
        return  self.imResultArr.count;
    }
    return self.qinmiDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 0) {
        HMMsgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HMMsgTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.imResultArr[indexPath.row];
        cell.imOnlineDic = self.imOnlineDic;
        [cell layoutIfNeeded];
        return cell;
    }else{
        HMQinmiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HMQinmiTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.qinModel = self.qinmiDataArray[indexPath.row];
        cell.qinmiIMArr = self.intimacyResultArr;
        cell.qinmiOnlineDic = self.qinmiOnlineDic;
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
    NSString * friendHeadStr = @"";
    NSString * friendNameStr = @"";
    NSString * conversationIdStr = @"";
    RLMResults *results = [PGMessageListModel allObjects];
    if (self.index == 0) {
        AgoraChatConversation * model = self.imResultArr[indexPath.row];
        for (PGMessageListModel * mm in results) {
            if ([mm.messageId integerValue] == [model.conversationId integerValue]) {
                friendHeadStr = mm.avatar;
                friendNameStr = mm.nickName;
            }
        }
        conversationIdStr = model.conversationId;
    }else{
        HMIntimacyListModel * model = self.qinmiDataArray[indexPath.row];
        for (PGMessageListModel * mm in results) {
            if ([mm.messageId integerValue] == [model.userid integerValue]) {
                friendHeadStr = mm.avatar;
                friendNameStr = mm.nickName;
            }
        }
        conversationIdStr = model.userid;
    }
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.friendHead = friendHeadStr;
    vc.friendName = friendNameStr;
    vc.channelId = conversationIdStr;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
/// 空数据UI
/// @param scrollView tableview
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = Localized(@"暂无消息");
    NSDictionary *attributes = @{NSFontAttributeName: MPFont(16),
                                 NSForegroundColorAttributeName: HEX(#000000)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return MPImage(@"empty");
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView; {
    return 0;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -STATUS_H_F;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
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
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"HMMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMMsgTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HMQinmiTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMQinmiTableViewCell"];
    }
    return _tableView;
}
//- (NSMutableArray *)dataArray
//{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}
- (NSDictionary *)imOnlineDic
{
    if (!_imOnlineDic) {
        _imOnlineDic = [NSDictionary dictionary];
    }
    return _imOnlineDic;
}
- (NSDictionary *)qinmiOnlineDic
{
    if (!_qinmiOnlineDic) {
        _qinmiOnlineDic = [NSDictionary dictionary];
    }
    return _qinmiOnlineDic;
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
