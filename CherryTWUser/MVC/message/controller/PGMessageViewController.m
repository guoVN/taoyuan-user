//
//  PGMessageViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/2.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGMessageViewController.h"
#import "PGNavigationViewController.h"
#import "PGMessageListViewController.h"
#import "PGContainerVC.h"
#import "HMIntimacyListModel.h"

@interface PGMessageViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) UIImageView * topBg;
@property (nonatomic, strong) JXCategoryNumberView * jxCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;
@property (nonatomic, strong) JXCategoryIndicatorLineView *lineView;
@property (nonatomic, strong) NSMutableArray * segArray;
@property (nonatomic, strong) NSArray *numbers;

@property (nonatomic, strong) NSMutableArray * imResultArr;
@property (nonatomic, strong) NSMutableArray * intimacyResultArr;
@property (nonatomic, strong) NSMutableArray * qinmiDataArr;

@end

@implementation PGMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    BOOL imLogin = AgoraChatClient.sharedClient.isLoggedIn;
    if (!imLogin) {
        [PGUtils loginIM:[PGManager shareModel].userInfo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];
        });
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"RefreshMsg" object:nil];
}
- (void)loadUI
{
    self.view.backgroundColor = HEX(#FFFFFF);
    [self.view addSubview:self.topBg];
    self.segArray = [@[Localized(@"消息"),Localized(@"亲密消息")] mutableCopy];
    [self.view addSubview:self.jxCategoryView];
    //关联到categoryView
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.jxCategoryView.listContainer = self.listContainerView;
    [self.jxCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+5);
        make.height.mas_equalTo(60);
    }];
    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.jxCategoryView.mas_bottom);
        make.bottom.mas_equalTo(-SafeBottom-49);
    }];
    [self.jxCategoryView reloadData];
}
- (void)loadData
{
    WeakSelf(self)
    [PGAPIService intimacyListWithParameters:@{@"userId":[PGManager shareModel].userInfo.userid} Success:^(id  _Nonnull data) {
        NSArray * items = [HMIntimacyListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [weakself dealMSgData:items];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [weakself dealMSgData:@[]];
        [QMUITips showWithText:message];
    }];
}
- (void)dealMSgData:(NSArray *)qinmiArray
{
    self.qinmiDataArr = [NSMutableArray arrayWithArray:qinmiArray];
    NSArray <AgoraChatConversation *>*conversations = [AgoraChatClient.sharedClient.chatManager getAllConversations:YES];
    NSInteger unreadCount = 0;
    NSMutableArray * userIdArr = [NSMutableArray array];
    NSMutableArray<AgoraChatConversation *> * msgConversations = [NSMutableArray array];
    for (AgoraChatConversation *conversation in conversations) {
        if (![conversation.conversationId isEqualToString:@"99999999"]) {
            AgoraChatMessage * last = conversation.latestMessage;
            if (last.conversationId>0) {
                unreadCount += conversation.unreadMessagesCount;
                [userIdArr addObject:conversation.conversationId];
                [msgConversations addObject:conversation];
            }
        }
        NSArray<AgoraChatMessage *> *messages = [conversation loadMessagesStartFromId:0 count:10 searchDirection:0];
        for (NSInteger i=messages.count-1; i>=0; i--) {
            AgoraChatMessage * ch = messages[i];
            AgoraChatTextMessageBody *textBody = (AgoraChatTextMessageBody *)ch.body;
            NSDictionary * msgDic = [PGUtils jsonToObject:textBody.text];
            if ([msgDic isKindOfClass:[NSNull class]]) {
                break;
            }
            NSString * msgType = msgDic[@"type"];
            if ([msgType isKindOfClass:[NSNull class]]) {
                msgDic = [PGUtils jsonToObject:msgDic[@"content"]];
            }
            NSString * isHiMsg = [msgDic[@"isReply"] integerValue] == 3 ? @"1" : @"0";
            if ([isHiMsg integerValue] == 1) {
                if (i-1>=0) {
                    AgoraChatMessage * up = messages[i-1];
                    if (ch.timestamp/1000-up.timestamp/1000>60) {
                        for (NSInteger j=0; j<=i-1; j++) {
                            AgoraChatMessage * dd = messages[j];
                            [conversation deleteMessageWithId:dd.messageId error:nil];
                        }
                    }
                }
            }
        }
    }
    
    [[[AgoraChatClient sharedClient] presenceManager] subscribe:userIdArr expiry:7*24*3600 completion:^(NSArray<AgoraChatPresence *> *presences, AgoraChatError *error) {
    }];

    PGNavigationViewController * nav = (PGNavigationViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    PGContainerVC * tabbarVC = (PGContainerVC *)nav.topViewController;
    if (![tabbarVC isKindOfClass:[PGContainerVC class]]) {
        return;
    }
    [tabbarVC.floatingTabBar setBadgeValue:[NSString stringWithFormat:@"%ld",unreadCount] forIndex:2];
    if (unreadCount == 0) {
        [tabbarVC.floatingTabBar setBadgeValue:nil forIndex:2];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
    
    NSMutableArray * intimacyResultArr = [NSMutableArray array];
    NSInteger intimacyUnReadCount = 0;
    for (AgoraChatConversation * imModel in msgConversations) {
        for (HMIntimacyListModel * intimacyModel in qinmiArray) {
            if ([intimacyModel.userid isEqualToString:imModel.conversationId]) {
                [intimacyResultArr addObject:imModel];
                intimacyUnReadCount += imModel.unreadMessagesCount;
            }
        }
    }
    
    NSSet *smallSet = [NSSet setWithArray:intimacyResultArr];
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in msgConversations) {
        if (![smallSet containsObject:obj]) {
            [result addObject:obj];
        }
    }
    NSMutableArray * imResultArr = [result mutableCopy];
    self.imResultArr = imResultArr;
    self.intimacyResultArr = intimacyResultArr;
    self.numbers = @[@(unreadCount-intimacyUnReadCount),@(intimacyUnReadCount)];
    self.jxCategoryView.counts = self.numbers;
    [self.jxCategoryView reloadData];
}
#pragma mark=== JXCategoryViewDelegate
//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index
{
    
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index
{
    
}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio
{
    
}
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index
{
    return YES;
}
//返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.segArray.count;
}
//根据下标index返回对应遵从`JXCategoryListContentViewDelegate`协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    PGMessageListViewController * vc= [[PGMessageListViewController alloc] init];
    vc.index = index;
    vc.imResultArr = self.imResultArr;
    vc.intimacyResultArr = self.intimacyResultArr;
    vc.qinmiDataArray = self.qinmiDataArr;
    return vc;
}

- (JXCategoryNumberView *)jxCategoryView
{
    if (!_jxCategoryView) {
        _jxCategoryView = [[JXCategoryNumberView alloc] init];
        _jxCategoryView.backgroundColor = UIColor.clearColor;
        _jxCategoryView.numberBackgroundColor = [UIColor redColor];
        _jxCategoryView.numberLabelOffset = CGPointMake(0, 2);
        _jxCategoryView.delegate = self;
        _jxCategoryView.titles = self.segArray;
        _jxCategoryView.defaultSelectedIndex = 0;
        _jxCategoryView.indicators = @[self.lineView];
        _jxCategoryView.titleFont = MPBoldFont(16);
        _jxCategoryView.titleColor = HEX(#000000);
        _jxCategoryView.titleSelectedFont = MPHeavyFont(24);
        _jxCategoryView.titleSelectedColor = HEX(#000000);
        _jxCategoryView.averageCellSpacingEnabled = NO;
        _jxCategoryView.contentEdgeInsetLeft = 22;
        _jxCategoryView.cellSpacing = 30;
    }
    return _jxCategoryView;
}

- (JXCategoryIndicatorLineView *)lineView
{
    if (!_lineView) {
        _lineView = [[JXCategoryIndicatorLineView alloc] init];
        _lineView.indicatorColor = THEAME_COLOR;
        _lineView.indicatorWidth = 20;
        _lineView.indicatorHeight = 6;
        _lineView.verticalMargin = 8;
    }
    return _lineView;
}
- (UIImageView *)topBg
{
    if (!_topBg) {
        _topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, STATUS_H_F+300)];
        _topBg.contentMode = UIViewContentModeScaleAspectFill;
        [_topBg setImage:MPImage(@"homeBg")];
    }
    return _topBg;
}
- (NSMutableArray *)imResultArr
{
    if (!_imResultArr) {
        _imResultArr = [NSMutableArray array];
    }
    return _imResultArr;
}
- (NSMutableArray *)intimacyResultArr
{
    if (!_intimacyResultArr) {
        _intimacyResultArr = [NSMutableArray array];
    }
    return _intimacyResultArr;
}
- (NSMutableArray *)qinmiDataArr
{
    if (!_qinmiDataArr) {
        _qinmiDataArr = [NSMutableArray array];
    }
    return _qinmiDataArr;
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
