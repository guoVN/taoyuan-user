//
//  PGPublishDynamicCollectionViewCell.h
//  CherryTWUser
//
//  Created by guo on 2024/12/5.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGPublishDynamicCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *chooseImg;
@property (weak, nonatomic) IBOutlet UIImageView *addImg;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (nonatomic, assign) BOOL isEditStatus;
@property (nonatomic, copy) void(^deleteImgBlock)(void);

@end

NS_ASSUME_NONNULL_END
