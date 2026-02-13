//
//  PGDynamicListCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2025/10/23.
//  Copyright © 2025 guo. All rights reserved.
//

#import "PGDynamicListCollectionViewCell.h"
#import "PGPersonalDetailViewController.h"
#import "PGPlayerViewController.h"

@implementation PGDynamicListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPreView:)]];
    [self.playImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPreView:)]];
}

- (void)setModel:(PGAnchorDynamicModel *)model
{
    _model = model;
    self.playImg.alpha = 0;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:MPImage(@"netFaild")];
    self.nameLabel.text = model.nickName;
    self.contentLabel.text = model.content;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",model.likeNum] forState:UIControlStateNormal];
    self.praiseBtn.selected = [model.isLike isEqualToString:@"Y"] ? YES : NO;
    NSArray * imgArr = [model.photoUrl componentsSeparatedByString:@","];
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:imgArr.firstObject]];
    if (model.photoUrl.length == 0 && model.videoUrl.length>0) {
        if (self.contentImg.image == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[PGManager shareModel] getVideoThumbnailAsync:[NSURL URLWithString:model.videoUrl] completion:^(UIImage *thumbnail) {
                    self.contentImg.image = thumbnail;
                }];
            });
        }
        self.playImg.alpha = 1;
    }
}
- (void)clickPreView:(UITapGestureRecognizer *)ges
{
    NSArray * imgArr = [self.model.photoUrl componentsSeparatedByString:@","];
    if (imgArr.count>0) {
        [HUPhotoBrowser showFromImageView:self.contentImg withURLStrings:imgArr atIndex:0];
    }
    if (self.model.videoUrl.length>0 && self.model.photoUrl.length == 0) {
        PGPlayerViewController * vc = [[PGPlayerViewController alloc] init];
        vc.modalPresentationStyle = 0;
        vc.videoUrlStr = self.model.videoUrl;
        [[PGUtils getCurrentVC] presentViewController:vc animated:YES completion:nil];
    }
}
- (IBAction)praiseBtnAction:(id)sender {
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:@(self.model.dynamicid) forKey:@"dynamicid"];
    [PGAPIService dynamicPraiseWithParameters:dic Success:^(id  _Nonnull data) {
        weakself.model.isLike = @"Y";
        weakself.model.likeNum +=1;
        weakself.model = weakself.model;
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips showWithText:message];
    }];
}

@end
