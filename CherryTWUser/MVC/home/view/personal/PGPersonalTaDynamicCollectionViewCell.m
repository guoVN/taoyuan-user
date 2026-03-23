//
//  PGPersonalTaDynamicCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/4.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPersonalTaDynamicCollectionViewCell.h"
#import "PGAnchorDynamicListViewController.h"

@implementation PGPersonalTaDynamicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backView yd_setVeticalGradualWithColors:@[HEXAlpha(#FFFFFF, 0),HEXAlpha(#5A5151, 0.2),HEXAlpha(#606060, 0.3)] locations:@[@0,@0.2,@1.0]];
    [self.coverImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCover)]];
}

- (void)setDynamicModel:(PGAnchorDynamicModel *)dynamicModel
{
    _dynamicModel = dynamicModel;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:dynamicModel.photoUrl] placeholderImage:MPImage(@"netFaild")];
    self.contentLabel.text = dynamicModel.content;
    self.playImg.alpha = dynamicModel.videoUrl.length>0?1:0;
    if (dynamicModel.photoUrl.length == 0 && dynamicModel.videoUrl.length>0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[PGManager shareModel] getVideoThumbnailAsync:[NSURL URLWithString:dynamicModel.videoUrl] completion:^(UIImage *thumbnail) {
                self.coverImg.image = thumbnail;
            }];
        });
    }
}

- (void)clickCover
{
//    [HUPhotoBrowser showFromImageView:self.coverImg withURLStrings:@[self.dynamicModel.photoUrl] atIndex:0];
    PGAnchorDynamicListViewController * vc = [[PGAnchorDynamicListViewController alloc] init];
    vc.anchorid = [NSString stringWithFormat:@"%ld",self.dynamicModel.userid];
    [[PGUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

@end
