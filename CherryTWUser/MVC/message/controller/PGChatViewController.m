//
//  PGChatViewController.m
//  CherryTWUser
//
//  Created by guo on 2024/12/12.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGChatViewController.h"
#import "PGVideoCallViewController.h"
#import "PGNavigationViewController.h"
#import "PGReportViewController.h"
//model
#import "PGMessageListModel.h"
#import "PGAnchorModel.h"
#import "PGAnchorPriceModel.h"
//view
#import "PGChatInputView.h"
#import "PGChatNavigationView.h"
#import "PGChatLeftTableViewCell.h"
#import "PGChatRightTableViewCell.h"
#import "PGLeftAudioTableViewCell.h"
#import "PGRightAudioTableViewCell.h"
#import "PGLeftImgTableViewCell.h"
#import "PGRightImgTableViewCell.h"
#import "HMGiftView.h"
#import "PGCustomAlertView.h"
#import "PGChatTableHeaderView.h"
#import "PGUnlockChatAlertView.h"

@interface PGChatViewController ()<UITableViewDataSource,UITableViewDelegate,PGChatInputViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) PGChatInputView * chatInputView;
@property (nonatomic, strong) PGMessageListModel * currentChatModel;
@property (nonatomic, strong) PGAnchorPriceModel * priceModel;
@property (nonatomic, strong) PGAnchorModel * anchorDetailModel;
@property (nonatomic, strong) QMUIButton * varifyBtn;

@end

@implementation PGChatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable =NO;
    [self readMsg];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable =YES;
    [self readMsg];
}
- (void)readMsg
{
    AgoraChatConversation *conversation = [[AgoraChatClient sharedClient].chatManager getConversation:self.channelId type:AgoraChatConversationTypeChat createIfNotExist:YES];
    [conversation markAllMessagesAsRead:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
//    [self loadCallPrice];
//    [self loadAnchorDetail];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkMsg:) name:@"RefreshMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVideocallMsg:) name:@"RefreshVideoCallType" object:nil];
}
- (void)loadUI
{
    self.view.backgroundColor = HEX(#FFFFFF);
    self.titleStr = self.friendName;
    [self.view addSubview:self.chatInputView];
    [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(SafeBottom+94);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(STATUS_H_F+44);
        make.bottom.equalTo(self.chatInputView.mas_top);
    }];
    [self.view addSubview:self.varifyBtn];
    [self.varifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.chatInputView.mas_top).offset(-30);
        make.size.mas_equalTo(CGSizeMake(45, 64));
    }];
}
- (void)dealTableView:(BOOL)animated
{
    if (self.dataArray.count>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.dataArray.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    CGFloat height = keyboardHeight-SafeBottom;
    [UIView animateWithDuration:0.5 animations:^{
        self.chatInputView.qmui_bottom = ScreenHeight-height;
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-height);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dealTableView:YES];
        });
    }];
}
- (void)keyboardHide:(NSNotification *)notification
{
    self.chatInputView.qmui_bottom = ScreenHeight;
    [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    self.chatInputView.emojiBtn.selected = NO;
    self.chatInputView.inputField.inputView = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dealTableView:YES];
    });
}
- (void)checkMsg:(NSNotification *)notification
{
    NSDictionary * dic = notification.userInfo;
    if ([dic[@"senderid"] isEqualToString:self.channelId]) {
        [self loadData];
    }
}
- (void)updateVideocallMsg:(NSNotification *)notification
{
    NSDictionary * dic = notification.userInfo;
    NSString * status = [NSString stringWithFormat:@"%@ ",dic[@"status"]];
    AgoraChatConversation *conversation = [AgoraChatClient.sharedClient.chatManager getConversationWithConvId:self.channelId];
    AgoraChatError *error;
    [conversation deleteMessageWithId:[PGManager shareModel].currentCallMsgId error:&error];
    [self sendMsgWith:status withType:@"文字"];
//    [self.tableView reloadData];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self dealTableView:NO];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self loadData];
//    });
}
- (void)loadCallPrice
{
    WeakSelf(self)
    [PGAPIService getCallPriceWithParameters:@{@"userid":self.channelId} Success:^(id  _Nonnull data) {
        PGAnchorPriceModel * priceModel = [PGAnchorPriceModel mj_objectWithKeyValues:data[@"data"]];
        weakself.priceModel = priceModel;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)loadAnchorDetail
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.channelId forKey:@"anchorid"];
    [QMUITips showLoadingInView:self.view];
    [PGAPIService anchorDetailWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        id aa = data[@"data"];
        if ([aa isKindOfClass:[NSNull class]]) {
            [PGManager shareModel].callCoin = 0;
        }else{
            PGAnchorModel * model = [PGAnchorModel mj_objectWithKeyValues:data[@"data"]];
            [PGManager shareModel].callCoin = [model.videoCoin integerValue];
        }
        weakself.anchorDetailModel = [PGAnchorModel mj_objectWithKeyValues:data[@"data"]];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)loadData
{
    // 获取指定会话 ID 的会话。
    AgoraChatConversation *conversation = [[AgoraChatClient sharedClient].chatManager getConversation:self.channelId type:0 createIfNotExist:YES];
    //startMsgId：查询的起始消息 ID； count：每次获取的消息条数。如果设为小于等于 0，SDK 获取 1 条消息。
    //searchDirection：消息搜索方向。若消息方向为 `UP`，按消息时间戳的降序获取；若为 `DOWN`，按消息时间戳的升序获取。
    NSArray<AgoraChatMessage *> *messages = [conversation loadMessagesStartFromId:0 count:10 searchDirection:0];

    self.dataArray = [messages mutableCopy];
//    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dealTableView:YES];
    });
}
- (void)loadHistoryData
{
    AgoraChatMessage * topMessage = self.dataArray.firstObject;
    // 获取指定会话 ID 的会话。
    AgoraChatConversation *conversation = [[AgoraChatClient sharedClient].chatManager getConversation:self.channelId type:0 createIfNotExist:YES];
    //startMsgId：查询的起始消息 ID； count：每次获取的消息条数。如果设为小于等于 0，SDK 获取 1 条消息。
    //searchDirection：消息搜索方向。若消息方向为 `UP`，按消息时间戳的降序获取；若为 `DOWN`，按消息时间戳的升序获取。
    NSArray<AgoraChatMessage *> *messages = [conversation loadMessagesStartFromId:topMessage.messageId count:10 searchDirection:0];
 
    [self.dataArray insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messages.count)]];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AgoraChatMessage * chatModel = self.dataArray[indexPath.section];
    AgoraChatTextMessageBody * textBody = (AgoraChatTextMessageBody *)chatModel.body;
    NSDictionary * msgDic = [PGUtils jsonToObject:textBody.text];
    NSString * msgType = msgDic[@"type"];
    if ([msgType isKindOfClass:[NSNull class]]) {
        msgDic = [PGUtils jsonToObject:msgDic[@"content"]];
        msgType = msgDic[@"type"];
    }
    NSString * senderId = [NSString stringWithFormat:@"%@",msgDic[@"senderid"]];
    NSString * contentStr = msgDic[@"content"];
    if ([senderId isEqualToString:[PGManager shareModel].userInfo.userid]) {
        if ([msgType isEqualToString:@"图片"] || [msgType isEqualToString:@"local_pic"]) {
            PGRightImgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGRightImgTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.msdDic = msgDic;
            [cell layoutIfNeeded];
            return cell;
        }else if ([msgType isEqualToString:@"语音"] || [msgType isEqualToString:@"local_voice"]){
            PGRightAudioTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGRightAudioTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.msdDic = msgDic;
            [cell layoutIfNeeded];
            return cell;
        }else{
            if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"图片"] || [[PGUtils getFileFormat:contentStr] isEqualToString:@"视频"]) {
                PGRightImgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGRightImgTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.msdDic = msgDic;
                [cell layoutIfNeeded];
                return cell;
            }else if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"语音"]){
                PGRightAudioTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGRightAudioTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.msdDic = msgDic;
                [cell layoutIfNeeded];
                return cell;
            }else{
                PGChatRightTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGChatRightTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.messageId = chatModel.messageId;
                cell.msdDic = msgDic;
                [cell layoutIfNeeded];
                return cell;
            }
        }
    }else{
        if ([msgType isEqualToString:@"图片"] || [msgType isEqualToString:@"local_pic"]) {
            PGLeftImgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGLeftImgTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.channelId = self.channelId;
            cell.friendHead = self.friendHead;
            cell.msdDic = msgDic;
            [cell layoutIfNeeded];
            return cell;
        }else if ([msgType isEqualToString:@"语音"] || [msgType isEqualToString:@"local_voice"]){
            PGLeftAudioTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGLeftAudioTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.channelId = self.channelId;
            cell.friendHead = self.friendHead;
            cell.msdDic = msgDic;
            [cell layoutIfNeeded];
            return cell;
        }else{
            if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"图片"] || [[PGUtils getFileFormat:contentStr] isEqualToString:@"视频"]) {
                PGLeftImgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGLeftImgTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.channelId = self.channelId;
                cell.friendHead = self.friendHead;
                cell.msdDic = msgDic;
                [cell layoutIfNeeded];
                return cell;
            }else if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"语音"]){
                PGLeftAudioTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGLeftAudioTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.channelId = self.channelId;
                cell.friendHead = self.friendHead;
                cell.msdDic = msgDic;
                [cell layoutIfNeeded];
                return cell;
            }else{
                PGChatLeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PGChatLeftTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.channelId = self.channelId;
                cell.messageId = chatModel.messageId;
                cell.friendHead = self.friendHead;
                cell.msdDic = msgDic;
                [cell layoutIfNeeded];
                return cell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
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
#pragma mark===PGChatInputViewDelegate
///语音录制完毕
- (void)inputBar:(PGChatInputView *)textView didSendVoice:(NSString *)path
{
    WeakSelf(self)
    [PGAPIService uploadFileWithAudio:path Success:^(id  _Nonnull data) {
        NSString * audioUrl = data[@"data"];
        [weakself sendMsgWith:audioUrl withType:@"文字"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showWithText:@"语音发送失败"];
    }];
}

#pragma mark===礼物
- (void)giftBtnAction
{
    [self.chatInputView.inputField resignFirstResponder];
    WeakSelf(self)
    [[PGManager shareModel].mainControlAlert closeView];
    [PGManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonCurverOn)
        .wHideAnimationSet(AninatonCurverOff)
        .wPointSet(CGPointMake(0, ScreenHeight-332-SafeBottom))
        .wShadowCanTapSet(YES)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMGiftView *view = [[HMGiftView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 332+SafeBottom) superView:mainView];
                view.channelId = self.channelId;
                view.sendGiftBlock = ^(NSString * _Nonnull giftName) {
                    [weakself sendMsgWith:giftName withType:@"礼物"];
                };
                return view;
            })
        .wStart();
}
#pragma mark===发送消息
- (void)sendMsgWith:(NSString *)sendContent withType:(NSString *)type
{
    if (self.channelId.length == 0) {
        return;
    }
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"senderId"];
    [dic setValue:self.channelId forKey:@"recipientId"];
    [PGAPIService checkBlackenedWithParameters:dic Success:^(id  _Nonnull data) {
        NSDictionary * dataDic = data[@"data"];
        BOOL isBlackAnchor = [dataDic[@"senderBlockRecipient"] boolValue];
        BOOL isBeBlack = [dataDic[@"recipientBlockSender"] boolValue];
        if (!isBlackAnchor && !isBeBlack) {
            [weakself doSendMsgActionWith:sendContent withType:type];
        }else{
            if (isBlackAnchor) {
                [QMUITips showWithText:@"你已拉黑对方"];
            }else if (isBeBlack){
                [QMUITips showWithText:@"你已被对方拉黑"];
            }
        }
    } failure:^(NSInteger code, NSString * _Nonnull message) {
       
    }];
}
- (void)sendMsgCheckPre:(NSString *)sendContent withType:(NSString *)type
{
    NSString * sendType = @"3";
    if ([type isEqualToString:@"视频"]) {
        sendType = @"2";
    }
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:self.channelId forKey:@"anchorId"];
    [dic setValue:@"" forKey:@"virtualAnchorId"];
    [dic setValue:sendType forKey:@"type"];//1-语音通话 2-视频通话 3-消息
    [PGAPIService videoCheckPreChargingWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips hideAllTips];
        [weakself doSendMsgActionWith:sendContent withType:type];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)doSendMsgActionWith:(NSString *)sendContent withType:(NSString *)type
{
    BOOL isGift = [type isEqualToString:@"礼物"] ? true : false;
    NSDictionary * dic = @{@"type":type,@"content":sendContent,@"address":@"",@"bindId":@"",@"friendId":self.channelId,@"isGift":@(isGift),@"isReply":@"0",@"senderName":[PGManager shareModel].userInfo.nickName,@"senderPhoto":[PGManager shareModel].userInfo.photo,@"senderid":[PGManager shareModel].userInfo.userid};
    NSString * msgStr = [PGUtils objectToJson:dic];
    WeakSelf(self)
    AgoraChatTextMessageBody *textMessageBody = [[AgoraChatTextMessageBody alloc] initWithText:msgStr];
    // 消息接收方，单聊为对端用户的 ID，群聊为群组 ID，聊天室为聊天室 ID。
    NSString* conversationId = self.channelId;
    AgoraChatMessage *message = [[AgoraChatMessage alloc] initWithConversationID:conversationId
                                                          body:textMessageBody
                                                                   ext:nil];
    message.ext = @{@"em_apns_ext":@{
        @"em_push_title": [PGManager shareModel].userInfo.nickName,
        @"em_push_content": [type isEqualToString:@"文字"] ? sendContent : [NSString stringWithFormat:@"[%@]",type]
    }};
    // 会话类型，单聊为 `AgoraChatTypeChat`，群聊为 `AgoraChatTypeGroupChat`，聊天室为 `AgoraChatTypeChatRoom`，默认为单聊。
    message.chatType = AgoraChatTypeChat;
    // 发送消息。
    [[AgoraChatClient sharedClient].chatManager sendMessage:message
                                            progress:nil
                                                 completion:^(AgoraChatMessage * _Nullable message, AgoraChatError * _Nullable error) {
        if (!error) {
//            if ([type isEqualToString:@"视频"]) {
//                PGVideoCallViewController * vc = [[PGVideoCallViewController alloc] init];
//                vc.channelId = weakself.channelId;
//                vc.callType = 1;
//                vc.dataDic = dic;
//                vc.anchorName = weakself.friendName;
//                vc.anchorHeadStr = weakself.friendHead;
//                vc.priceModel = weakself.priceModel;
//                PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
//                nav.modalPresentationStyle = 0;
//                [weakself presentViewController:nav animated:YES completion:nil];
//            }else if ([type isEqualToString:@"文字"]){
//                [weakself messageChargeAction:sendContent withType:type];
//            }
            if ([type isEqualToString:@"视频"]) {
                [PGManager shareModel].currentCallMsgId = message.messageId;
                [PGManager shareModel].currentCallConversationId = message.conversationId;
                PGVideoCallViewController * vc = [[PGVideoCallViewController alloc] init];
                vc.channelId = weakself.channelId;
                vc.callType = 1;
                vc.dataDic = dic;
                vc.anchorName = weakself.friendName;
                vc.anchorHeadStr = weakself.friendHead;
                vc.priceModel = weakself.priceModel;
                PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = 0;
                [weakself presentViewController:nav animated:YES completion:nil];
            }else{
                [weakself.dataArray addObject:message];
                [weakself.tableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dealTableView:NO];
                });
            }
            [weakself addMsgRecord:sendContent];
        }
    }];
}
- (void)addMsgRecord:(NSString *)content
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.channelId forKey:@"friendid"];
    [dic setValue:content forKey:@"content"];
    [dic setValue:@"" forKey:@"virtualAnchorid"];
    [PGAPIService messageSendAddRecordWithParameters:dic Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
#pragma mark===举报拉黑
- (void)blackAnchorAction
{
    WeakSelf(self)
    PGCustomAlertView * alertView = [[PGCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    alertView.type = 7;
    [alertView.tipsImg setImage:MPImage(@"yiwen")];
    alertView.titleLabel.text = @"温馨提示";
    alertView.contentLabel.text = @"拉黑后，您将不再接收此用户任何消息确定拉黑她吗？";
    alertView.sureBlock = ^{
        [weakself doBlackAnchorAction];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:alertView];
}
- (void)doBlackAnchorAction
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:self.channelId forKey:@"targetid"];
    [dic setValue:@"1" forKey:@"isMultiple"];
    [PGAPIService blackAddWithParameters:dic Success:^(id  _Nonnull data) {
        [QMUITips showWithText:@"拉黑成功"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showWithText:message];
    }];
}
#pragma mark===颜值验证
- (void)varifyBtnAction
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
                view.type = 3;
                view.sureBlock = ^{
                   
                };
                return view;
            })
        .wStart();
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
        [_tableView registerNib:[UINib nibWithNibName:@"PGChatLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGChatLeftTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGChatRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGChatRightTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGLeftAudioTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGLeftAudioTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGRightAudioTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGRightAudioTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGLeftImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGLeftImgTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PGRightImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"PGRightImgTableViewCell"];
        WeakSelf(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself loadHistoryData];
        }];
    }
    return _tableView;
}
- (PGChatInputView *)chatInputView
{
    WeakSelf(self)
    if (!_chatInputView) {
        _chatInputView = [[PGChatInputView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SafeBottom+94)];
        _chatInputView.delegate = self;
        _chatInputView.channelId = self.channelId;
        _chatInputView.sendBlock = ^(NSString * _Nonnull sendContent) {
            [weakself sendMsgWith:sendContent withType:@"文字"];
            weakself.chatInputView.inputField.text = @"";
        };
        _chatInputView.sendImgBlock = ^(NSString * _Nonnull imgUrl) {
            [weakself sendMsgWith:imgUrl withType:@"文字"];
        };
        _chatInputView.sendVideoCallBlock = ^{
            [weakself sendMsgWith:@"" withType:@"视频"];
        };
        _chatInputView.chooseGiftBlock = ^{
            [weakself giftBtnAction];
        };
    }
    return _chatInputView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (QMUIButton *)varifyBtn
{
    if (!_varifyBtn) {
        _varifyBtn = [[QMUIButton alloc] init];
        UIImageView * icon = [[UIImageView alloc] init];
        [icon setImage:MPImage(@"verifyIcon")];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        [_varifyBtn addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(42);
        }];
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.font = MPMediumFont(11);
        titleLabel.textColor = HEX(#000000);
        titleLabel.text = Localized(@"颜值验证");
        [_varifyBtn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(icon.mas_bottom).offset(6);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(16);
        }];
        [_varifyBtn addTarget:self action:@selector(varifyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _varifyBtn;
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
