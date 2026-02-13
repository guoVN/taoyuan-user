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
    }
}

@end
