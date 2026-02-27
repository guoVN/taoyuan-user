//
//  PGQinmiCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2026/2/27.
//  Copyright © 2026 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMIntimacyListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGQinmiCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUIButton *qinmiduBtn;

@property (nonatomic, strong) HMIntimacyListModel * listModel;

@end

NS_ASSUME_NONNULL_END
