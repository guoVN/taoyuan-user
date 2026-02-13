//
//  HMAlbumCollectionViewCell.h
//  HoneyMelonAnchor
//
//  Created by guo on 2025/8/28.
//

#import <UIKit/UIKit.h>
#import "HMAlbumListModel.h"
#import "HMVideoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMAlbumCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;

@property (nonatomic, assign) NSInteger isVideo;
@property (nonatomic, assign) NSInteger isEidtPage;
@property (nonatomic, strong) HMAlbumListModel * model;

@property (nonatomic, strong) HMVideoListModel * videoModel;

@property (nonatomic, copy) void(^deleteImgBlock)(void);

@end

NS_ASSUME_NONNULL_END
