//
//  HMYuYueListCollectionViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/10/13.
//

#import "HMYuYueListCollectionViewCell.h"

@implementation HMYuYueListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTimeModel:(PGYuYueDataModelTimeModel *)timeModel
{
    _timeModel = timeModel;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld.00",timeModel.hourUnit];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.layer.borderColor = HEXAlpha(#000000, 0.2).CGColor;
    self.timeLabel.textColor = HEX(#666666);
    self.redView.alpha = 0;
    switch (timeModel.status) {
        case 0:
            self.timeLabel.text = Localized(@"休息");
            self.timeLabel.backgroundColor = HEXAlpha(#000000, 0.06);
            self.timeLabel.layer.borderColor = HEXAlpha(#000000, 0).CGColor;
            break;
        case 1:
            self.timeLabel.layer.borderColor = HEXAlpha(#000000, 0.2).CGColor;
            break;
        case 2:
            self.timeLabel.text = Localized(@"紧张");
            self.timeLabel.textColor = HEX(#FF6E21);
            self.timeLabel.backgroundColor = HEX(#FFF0E9);
            self.timeLabel.layer.borderColor = HEXAlpha(#000000, 0).CGColor;
            break;
        case 3:
            self.timeLabel.text = Localized(@"约满");
            self.timeLabel.textColor = HEX(#FF6B97);
            self.timeLabel.backgroundColor = HEX(#FFE3EB);
            self.timeLabel.layer.borderColor = HEXAlpha(#000000, 0).CGColor;
            break;
        case 4:
            self.timeLabel.backgroundColor = HEXAlpha(#000000, 0.03);
            self.timeLabel.layer.borderColor = HEXAlpha(#000000, 0).CGColor;
            self.timeLabel.text = @"";
            break;
        default:
            break;
    }
}

@end
