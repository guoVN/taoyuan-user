//
//  PGMessageViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/2.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGMessageViewController.h"
#import "PGMessageSystemViewController.h"
#import "PGChatViewController.h"
#import "PGWebViewController.h"
#import "PGContainerVC.h"
#import "PGNavigationViewController.h"
//model
#import "PGMessageListModel.h"
//view
#import "HMMsgTableViewCell.h"

@interface PGMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView * topBg;
@property (nonatomic, strong) UILabel * titleBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PGMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RefreshMsg" object:nil];
}
- (void)loadUI
{
    [self.view addSubview:self.topBg];
    [self.topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(466);
    }];
    [self.view addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(STATUS_H_F+19);
        make.height.mas_equalTo(29);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+54);
        make.bottom.mas_equalTo(-SafeBottom-49);
    }];
}
- (void)loadData
{
    NSArray <AgoraChatConversation *>*conversations = [AgoraChatClient.sharedClient.chatManager getAllConversations:YES];
    NSInteger unreadCount = 0;
    NSMutableArray * userIdArr = [NSMutableArray array];
    for (AgoraChatConversation *conversation in conversations) {
        if (![conversation.conversationId isEqualToString:@"99999999"]) {
            unreadCount += conversation.unreadMessagesCount;
            [userIdArr addObject:conversation.conversationId];
        }
    }
    
    [[[AgoraChatClient sharedClient] presenceManager] subscribe:userIdArr expiry:7*24*3600 completion:^(NSArray<AgoraChatPresence *> *presences, AgoraChatError *error) {
    }];

    PGNavigationViewController * nav = (PGNavigationViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    PGContainerVC * tabbarVC = (PGContainerVC *)nav.topViewController;
    [tabbarVC.floatingTabBar setBadgeValue:[NSString stringWithFormat:@"%ld",unreadCount] forIndex:2];
    if (unreadCount == 0) {
        [tabbarVC.floatingTabBar setBadgeValue:nil forIndex:2];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
    
    NSMutableArray * intimacyResultArr = [NSMutableArray array];
    NSInteger intimacyUnReadCount = 0;
    for (AgoraChatConversation * imModel in conversations) {
        AgoraChatMessageBody * lastMsg = imModel.latestMessage.body;
        if ([@"99999999" isEqualToString:imModel.conversationId] || lastMsg == nil) {
            [intimacyResultArr addObject:imModel];
            intimacyUnReadCount += imModel.unreadMessagesCount;
        }
    }
    
    NSSet *smallSet = [NSSet setWithArray:intimacyResultArr];
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in conversations) {
        if (![smallSet containsObject:obj]) {
            [result addObject:obj];
        }
    }
    self.dataArray = [result mutableCopy];
    [self.tableView reloadData];
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
    HMMsgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HMMsgTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    [cell layoutIfNeeded];
    return cell;
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
    AgoraChatConversation * model = self.dataArray[indexPath.row];
    NSString * friendHeadStr = @"";
    NSString * friendNameStr = @"";
    NSString * conversationIdStr = @"";
    RLMResults *results = [PGMessageListModel allObjects];
    for (PGMessageListModel * mm in results) {
        if ([mm.messageId integerValue] == [model.conversationId integerValue]) {
            friendHeadStr = mm.avatar;
            friendNameStr = mm.nickName;
        }
    }
    conversationIdStr = model.conversationId;
    PGChatViewController * vc = [[PGChatViewController alloc] init];
    vc.friendHead = friendHeadStr;
    vc.friendName = friendNameStr;
    vc.channelId = conversationIdStr;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
// iOS 13+ 推荐使用的滑动操作替代方法
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1. 创建“删除”操作（UIContextualAction 替代原来的 UITableViewRowAction）
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                              title:@"删除"
                                                                            handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // 2. 执行删除逻辑（与原代码逻辑一致）
   
        
        // 3. 必须调用 completionHandler，告知系统操作完成（YES 表示需要刷新行，NO 表示不刷新）
        completionHandler(YES);
    }];
    
    // 4. 设置操作按钮背景色（替代原来的 action.backgroundColor）
    deleteAction.backgroundColor = HEX(#EB4D3D);
    
    // 5. 返回滑动操作配置（可包含多个操作，这里仅“删除”）
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    // 可选：设置是否允许滑动到底删除（默认 YES，设置 NO 可禁用）
    config.performsFirstActionWithFullSwipe = NO;
    
    return config;
}
#pragma mark===客服
- (void)serviceBtnAction:(QMUIButton *)sender
{
    PGWebViewController * vc = [PGWebViewController controllerWithTitle:@"客服" url:[PGManager shareModel].searviceLinkStr];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_tableView registerNib:[UINib nibWithNibName:@"HMMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"HMMsgTableViewCell"];
    }
    return _tableView;
}

- (UILabel *)titleBtn
{
    if (!_titleBtn) {
        _titleBtn = [[UILabel alloc] init];
        _titleBtn.font = MPSemiboldFont(24);
        _titleBtn.textColor = HEX(#000000);
        _titleBtn.text = Localized(@"消息");
    }
    return _titleBtn;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UIImageView *)topBg
{
    if (!_topBg) {
        _topBg = [[UIImageView alloc] init];
        [_topBg setImage:MPImage(@"homeBg")];
        _topBg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topBg;
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
