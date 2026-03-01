//
//  HMPersonalInfoEditInfoTableViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/8/27.
//

#import "HMPersonalInfoEditInfoTableViewCell.h"

@implementation HMPersonalInfoEditInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.statusView.alpha = 0;
    self.descRC.constant = -4;
    self.statusLabel.text = @"";
    self.rightImgLC.constant = 0;
    self.rightImg.alpha = 1;
    if (indexPath.section == 1 && indexPath.row == 0) {
        self.descLabel.text = [PGManager shareModel].userInfo.nickName;
    }else if (self.indexPath.section == 1 && self.indexPath.row == 1) {
        self.rightImgLC.constant = -12;
        self.rightImg.alpha = 0;
        self.descLabel.text = [PGManager shareModel].userInfo.userid;
    }else if (self.indexPath.section == 1 && self.indexPath.row == 2) {
        NSString * signStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"signStr"];
        self.descLabel.text = signStr.length>0?signStr:@"未设置";
    }else if (self.indexPath.section == 1 && self.indexPath.row == 3) {
        self.rightImgLC.constant = -12;
        self.rightImg.alpha = 0;
        self.descLabel.text = @"男";
    }else if (self.indexPath.section == 1 && self.indexPath.row == 4) {
        self.descLabel.text = [PGManager shareModel].userInfo.age>0 ? [NSString stringWithFormat:@"%ld岁",[PGManager shareModel].userInfo.age] : @"未设置";
    }else if (self.indexPath.section == 1 && self.indexPath.row == 5) {
        self.descLabel.text = [PGManager shareModel].userInfo.height>0?[NSString stringWithFormat:@"%ldcm",[PGManager shareModel].userInfo.height] : @"未设置";
    }else if (self.indexPath.section == 1 && self.indexPath.row == 6) {
        self.descLabel.text = [PGManager shareModel].userInfo.weight>0?[NSString stringWithFormat:@"%ldkg",[PGManager shareModel].userInfo.weight] : @"未设置";
    }else if (self.indexPath.section == 1 && self.indexPath.row == 7) {
        self.descLabel.text = [PGManager shareModel].userInfo.emotionState.length>0?[PGManager shareModel].userInfo.emotionState : @"未设置";
    }
}

@end
