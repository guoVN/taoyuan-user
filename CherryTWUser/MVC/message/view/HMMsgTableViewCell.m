//
//  HMMsgTableViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/8/27.
//

#import "HMMsgTableViewCell.h"
#import "PGMessageListModel.h"
#import "PGPersonalDetailViewController.h"

@implementation HMMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)]];
    [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AgoraChatConversation *)model
{
    _model = model;
    self.unReadLabel.text = [NSString stringWithFormat:@"%d",model.unreadMessagesCount];
    self.unReadLabel.alpha = model.unreadMessagesCount;
//    self.contentView.backgroundColor = model.isPinned == YES ? HEXAlpha(#9797FF, 0.2) : HEX(#FFFFFF);
    self.timeLabel.text = [PGUtils ConvertsStringToTimeYDHM:[NSString stringWithFormat:@"%lld",model.latestMessage.timestamp]];
    AgoraChatMessageBody * lastMsg = model.latestMessage.body;
    if (lastMsg.type == AgoraChatMessageBodyTypeText) {
        AgoraChatTextMessageBody *textBody = (AgoraChatTextMessageBody *)lastMsg;
        NSString * msg = textBody.text;
        NSDictionary * dic = [PGUtils jsonToObject:msg];
        NSString * contetStr = dic[@"content"];
        NSString * messageType = dic[@"type"];
        if ([messageType isEqualToString:@"文字"]) {
            if ([[PGUtils getFileFormat:contetStr] isEqualToString:@"图片"]) {
                self.msgLabel.text = Localized(@"[图片]");
            }else if ([[PGUtils getFileFormat:contetStr] isEqualToString:@"视频"]){
                self.msgLabel.text = Localized(@"[视频]");
            }else if ([[PGUtils getFileFormat:contetStr] isEqualToString:@"语音"]){
                self.msgLabel.text = Localized(@"[语音]");
            }else{
//                NSArray * arr = [contetStr componentsSeparatedByString:@"!!@@##"];
//                self.msgLabel.text = arr.firstObject;
                self.msgLabel.text = contetStr;
            }
        }else if ([messageType isEqualToString:@"图片"] || [messageType isEqualToString:@"local_pic"]){
            self.msgLabel.text = Localized(@"[图片]");
        }else if ([messageType isEqualToString:@"视频"]){
            self.msgLabel.text = Localized(@"[视频通话]");
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
    
    RLMResults *results = [PGMessageListModel allObjects];
    for (PGMessageListModel * mm in results) {
        if ([mm.messageId integerValue] == [model.conversationId integerValue]) {
            [self.headImg sd_setImageWithURL:[NSURL URLWithString:mm.avatar] placeholderImage:MPImage(@"manDefault")];
            self.nameLabel.text = mm.nickName;
            if (mm.remarks.length>0) {
                self.nameLabel.text = [NSString stringWithFormat:@"%@-(%@)",mm.nickName,mm.remarks];
            }
        }
        
    }
    
//    [[AgoraChatClient sharedClient].userInfoManager fetchUserInfoById:@[model.conversationId] completion:^(NSDictionary<NSString *,AgoraChatUserInfo *> * _Nullable aUserDatas, AgoraChatError * _Nullable aError) {
//        if (!aError) {
////            NSString *nickname = aUserDatas.nickname;
////            NSString *avatarUrl = aUserDatas.avatarUrl;
//            // 更新会话列表的头像和昵称显示
//        }
//    }];
}
- (void)setImOnlineDic:(NSDictionary *)imOnlineDic
{
    _imOnlineDic = imOnlineDic;
    self.onlineView.alpha = [imOnlineDic[self.model.conversationId] isEqualToString:@"在线"] ? 1 :0;
}

- (IBAction)tonBtnAction:(QMUIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = HEX(#9797FF).CGColor;
    }else{
        sender.layer.borderColor = HEX(#F7799C).CGColor;
    }
    [AgoraChatClient.sharedClient.chatManager pinConversation:self.model.conversationId isPinned:sender.selected completionBlock:^(AgoraChatError * _Nullable error) {
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWMSG" object:nil userInfo:nil];
}

- (void)clickHead:(UITapGestureRecognizer *)tap
{
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = self.model.conversationId;
    vc.isFromChat = YES;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
