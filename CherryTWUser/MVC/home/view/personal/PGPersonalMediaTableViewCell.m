//
//  PGPersonalMediaTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/10/23.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGPersonalMediaTableViewCell.h"
#import "PGPlayerViewController.h"

@implementation PGPersonalMediaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupTopShadowWithCustomView];
    [self.firstImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImg:)]];
    [self.secondImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImg:)]];
    [self.showOneImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImg:)]];
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checSecondkImg:)]];
    [self.playImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checSecondkImg:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailModel:(PGAnchorModel *)detailModel
{
    _detailModel = detailModel;
    NSArray * imgs = detailModel.photoUrls;
    for (NSInteger i=0; i<imgs.count; i++) {
        if (i==0) {
            [self.firstImg sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
            [self.showOneImg sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        }else if (i==1){
            [self.secondImg sd_setImageWithURL:[NSURL URLWithString:imgs[i]]];
        }
    }
   
    if (detailModel.photoUrls.count == 1 && detailModel.videoUrls.count == 0) {
        self.firstImg.alpha = self.secondImg.alpha = 0;
        self.showOneImg.alpha = 1;
    }
    if (detailModel.videoUrls.count>0) {
        [self.secondImg sd_setImageWithURL:[NSURL URLWithString:detailModel.videoUrls.firstObject.thumbnailUrl]];
    }
    self.coverView.alpha = self.playImg.alpha = detailModel.videoUrls.count>0?1:0;
}

- (void)checkImg:(UITapGestureRecognizer *)ges
{
    NSInteger tag = ges.view.tag/100-1;
    [HUPhotoBrowser showFromImageView:(UIImageView *)ges.view withURLStrings:self.detailModel.photoUrls atIndex:tag];
}
- (void)checSecondkImg:(UITapGestureRecognizer *)ges
{
    if (self.detailModel.videoUrls.count>0) {
        PGPlayerViewController * vc = [[PGPlayerViewController alloc] init];
        vc.modalPresentationStyle = 0;
        vc.videoUrlStr = self.detailModel.videoUrls.firstObject.videoUrl;
        [[PGUtils getCurrentVC] presentViewController:vc animated:YES completion:nil];
    }else{
        NSInteger tag = ges.view.tag/100-1;
        [HUPhotoBrowser showFromImageView:(UIImageView *)ges.view withURLStrings:self.detailModel.photoUrls atIndex:tag];
    }
}

@end
