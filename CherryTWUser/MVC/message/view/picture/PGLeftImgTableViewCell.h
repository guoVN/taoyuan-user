//
//  PGLeftImgTableViewCell.h
//  CherryTWUser
//
//  Created by guo on 2025/1/2.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGLeftImgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *conImg;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic, copy) NSString * channelId;
@property (nonatomic, copy) NSString * friendHead;
@property (nonatomic, strong) NSDictionary * msdDic;

@end

NS_ASSUME_NONNULL_END
