//
//  PGPersonalVideoPriceTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/11/16.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PGPersonalVideoPriceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet QMUIButton *videoPriceBtnOne;
@property (weak, nonatomic) IBOutlet QMUIButton *videoPriceBtnTwo;
@property (weak, nonatomic) IBOutlet QMUIButton *videoPriceBtnThree;

@property (nonatomic, strong) PGAnchorModel * detailModel;

@end

NS_ASSUME_NONNULL_END
