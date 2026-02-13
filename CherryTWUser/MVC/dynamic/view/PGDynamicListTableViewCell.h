//
//  PGDynamicListTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/3.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGDynamicListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *imageShowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgShowViewHC;
@property (weak, nonatomic) IBOutlet QMUIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *viewBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *timeBtn;

@property (nonatomic, strong) PGAnchorDynamicModel * model;

@end

NS_ASSUME_NONNULL_END
