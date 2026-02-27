//
//  HMQinmiTableViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/9/24.
//

#import "HMQinmiTableViewCell.h"
#import "HMPersonalHomePageViewController.h"
#import "HMTAInfoAlertView.h"

@implementation HMQinmiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.topBtn setTitle:Localized(@"置顶") forState:UIControlStateNormal];
    [self.topBtn setTitle:Localized(@"取消置顶") forState:UIControlStateSelected];
    self.topBtn.jk_touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQinModel:(HMIntimacyListModel *)qinModel
{
    _qinModel = qinModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:qinModel.photo] placeholderImage:MPImage(@"manDefault")];
    self.nameLabel.text = qinModel.nickName;
    self.unReadLabel.alpha = 0;
    self.onlineView.alpha = [qinModel.state isEqualToString:@"在线"] ? 1 : 0;
    [self.qinmiBtn setTitle:[NSString stringWithFormat:@"%@℃",[HMUtils formatNumber:[qinModel.intimacy floatValue]]] forState:UIControlStateNormal];
}
- (void)setQinmiIMArr:(NSArray *)qinmiIMArr
{
    _qinmiIMArr = qinmiIMArr;
    for (AgoraChatConversation * model in qinmiIMArr) {
        if ([model.conversationId isEqualToString:self.qinModel.userid]) {
            self.unReadLabel.text = [NSString stringWithFormat:@"%d",model.unreadMessagesCount];
            self.unReadLabel.alpha = model.unreadMessagesCount;
            self.timeLabel.text = [HMUtils ConvertsStringToTimeYDHM:[NSString stringWithFormat:@"%lld",model.latestMessage.timestamp]];
            self.topBtn.selected = model.isPinned;
            self.topBtn.layer.borderColor = model.isPinned == YES ? HEX(#9797FF).CGColor : HEX(#F7799C).CGColor;
            self.contentView.backgroundColor = model.isPinned == YES ? HEXAlpha(#9797FF, 0.2) : HEX(#FFFFFF);
            AgoraChatMessageBody * lastMsg = model.latestMessage.body;
            if (lastMsg.type == AgoraChatMessageBodyTypeText) {
                AgoraChatTextMessageBody *textBody = (AgoraChatTextMessageBody *)lastMsg;
                NSString * msg = textBody.text;
                NSDictionary * dic = [HMUtils jsonToObject:msg];
                NSString * contetStr = dic[@"content"];
                NSString * messageType = dic[@"type"];
                if ([messageType isEqualToString:@"文字"]) {
                    if ([[HMUtils getFileFormat:contetStr] isEqualToString:@"图片"]) {
                        self.msgLabel.text = Localized(@"[图片]");
                    }else if ([[HMUtils getFileFormat:contetStr] isEqualToString:@"视频"]){
                        self.msgLabel.text = Localized(@"[视频]");
                    }else if ([[HMUtils getFileFormat:contetStr] isEqualToString:@"语音"]){
                        self.msgLabel.text = Localized(@"[语音]");
                    }else{
                        NSArray * arr = [contetStr componentsSeparatedByString:@"!!@@##"];
                        self.msgLabel.text = arr.firstObject;
                    }
                }else if ([messageType isEqualToString:@"图片"] || [messageType isEqualToString:@"local_pic"]){
                    self.msgLabel.text = Localized(@"[图片]");
                }else if ([messageType isEqualToString:@"视频"]){
                    self.msgLabel.text = Localized(@"[视频通话]");
                }else if ([messageType isEqualToString:@"语音"]){
                    self.msgLabel.text = Localized(@"[语音通话]");
                }else if ([messageType isEqualToString:@"语音"] || [messageType isEqualToString:@"local_voice"]){
                    self.msgLabel.text = Localized(@"[语音]");
                }else if ([messageType isEqualToString:@"礼物"]){
                    self.msgLabel.text = Localized(@"[礼物]");
                }else if ([messageType isEqualToString:@"视频卡"]){
                    self.msgLabel.text = Localized(@"[视频通话]");
                }else{
                    self.msgLabel.text = Localized(@"[视频通话]");
                }
            }
            
            RLMResults *results = [HMMsgListModel allObjects];
            for (HMMsgListModel * mm in results) {
                if ([mm.messageId integerValue] == [model.conversationId integerValue]) {
                    [self.headImg sd_setImageWithURL:[NSURL URLWithString:mm.avatar] placeholderImage:MPImage(@"manDefault")];
                    self.nameLabel.text = mm.nickName;
                    if (mm.remarks.length>0) {
                        self.nameLabel.text = [NSString stringWithFormat:@"%@-(%@)",mm.nickName,mm.remarks];
                    }
                }
                
            }
        }
    }
}
- (void)setQinmiOnlineDic:(NSDictionary *)qinmiOnlineDic
{
    _qinmiOnlineDic = qinmiOnlineDic;
    self.onlineView.alpha = [qinmiOnlineDic[self.qinModel.userid] isEqualToString:@"在线"] ? 1 :0;
}

- (IBAction)tonBtnAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = HEX(#9797FF).CGColor;
    }else{
        sender.layer.borderColor = HEX(#F7799C).CGColor;
    }
    [AgoraChatClient.sharedClient.chatManager pinConversation:self.qinModel.userid isPinned:sender.selected completionBlock:^(AgoraChatError * _Nullable error) {
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWMSG" object:nil userInfo:nil];
}

- (void)clickHead:(UITapGestureRecognizer *)tap
{
//    HMPersonalHomePageViewController * vc = [[HMPersonalHomePageViewController alloc] init];
//    vc.userId = [self.qinModel.userid integerValue];
//    [[HMUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
    __block HMOnlineDetailModel * model = [[HMOnlineDetailModel alloc] init];
     model.userid = [self.qinModel.userid integerValue];
    [[HMManager shareModel].mainControlAlert closeView];
    [HMManager shareModel].mainControlAlert = Dialog()
        .wLevelSet(999)
        .wTagSet(random()%100000)
        .wTypeSet(DialogTypeMyView)
        .wShowAnimationSet(AninatonZoomInCombin)
        .wHideAnimationSet(AninatonZoomOut)
        .wShadowCanTapSet(YES)
        .wMyDiaLogViewSet(^UIView *(UIView *mainView) {
            mainView.backgroundColor = [UIColor clearColor];
            HMTAInfoAlertView *view = [[HMTAInfoAlertView alloc] initWithFrame:CGRectMake(0, 0, 305, 289) superView:mainView];
                view.userModel = model;
                return view;
            })
        .wStart();
}

@end
