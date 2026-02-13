//
//  PGRightImgTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/1/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGRightImgTableViewCell.h"
#import "PGPlayerViewController.h"

@implementation PGRightImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.conImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMsdDic:(NSDictionary *)msdDic
{
    _msdDic = msdDic;
    WeakSelf(self)
    NSString * contentStr = msdDic[@"content"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[PGManager shareModel].userInfo.photo] placeholderImage:MPImage(@"womanDefault")];
    [self.conImg sd_setImageWithURL:[NSURL URLWithString:contentStr] placeholderImage:MPImage(@"netFaild")];
    NSString * mseeageType = [PGUtils getFileFormat:contentStr];
   self.playBtn.alpha = [mseeageType isEqualToString:@"视频"] ? 1 : 0;
   if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"视频"]) {
       self.playBtn.alpha = 1;
//       NSArray * videoArr = [contentStr componentsSeparatedByString:@";"];
//       [self.conImg sd_setImageWithURL:[NSURL URLWithString:videoArr.firstObject]];
       [[PGManager shareModel] getVideoThumbnailAsync:[NSURL URLWithString:contentStr] completion:^(UIImage *thumbnail) {
           [weakself.conImg setImage:thumbnail];
       }];
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
- (IBAction)playBtnAction:(id)sender {
    PGPlayerViewController * vc = [[PGPlayerViewController alloc] init];
    vc.modalPresentationStyle = 0;
    vc.videoUrlStr = self.msdDic[@"content"];
    [[PGUtils getCurrentVC] presentViewController:vc animated:YES completion:nil];
}

@end
