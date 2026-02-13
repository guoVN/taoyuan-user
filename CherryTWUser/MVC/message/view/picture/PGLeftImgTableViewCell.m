//
//  PGLeftImgTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/1/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGLeftImgTableViewCell.h"
#import "PGPlayerViewController.h"
#import "PGPersonalDetailViewController.h"

@implementation PGLeftImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.conImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg)]];
    [self.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMsdDic:(NSDictionary *)msdDic
{
    _msdDic = msdDic;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:self.friendHead]];
    NSString * contentStr = msdDic[@"content"];
    [self.conImg sd_setImageWithURL:[NSURL URLWithString:contentStr] placeholderImage:MPImage(@"netFaild")];
    NSString * mseeageType = [PGUtils getFileFormat:contentStr];
   self.playBtn.alpha = [mseeageType isEqualToString:@"视频"] ? 1 : 0;
   if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"视频"]) {
       self.playBtn.alpha = 1;
       NSArray * videoArr = [contentStr componentsSeparatedByString:@";"];
       [self.conImg sd_setImageWithURL:[NSURL URLWithString:videoArr.firstObject]];
   }else{
       self.playBtn.alpha = 0;
   }
}

- (void)tapImg{
    [[PGUtils getCurrentVC].view endEditing:YES];
    NSString * contentStr = self.msdDic[@"content"];
    if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"图片"]) {
        [HUPhotoBrowser showFromImageView:self.conImg withURLStrings:@[contentStr] atIndex:0];
    }else{
        [self playBtnAction:self.playBtn];
    }
}
- (void)headClick
{
    PGPersonalDetailViewController * vc = [[PGPersonalDetailViewController alloc] init];
    vc.anchorid = self.channelId;
    vc.isFromChat = YES;
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)playBtnAction:(id)sender {
    [[PGUtils getCurrentVC].view endEditing:YES];
    PGPlayerViewController * vc = [[PGPlayerViewController alloc] init];
    vc.modalPresentationStyle = 0;
    vc.videoUrlStr = self.msdDic[@"content"];
    [[PGUtils getCurrentVC] presentViewController:vc animated:YES completion:nil];
}

@end
