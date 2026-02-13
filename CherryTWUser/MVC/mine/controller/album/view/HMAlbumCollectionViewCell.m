//
//  HMAlbumCollectionViewCell.m
//  HoneyMelonAnchor
//
//  Created by guo on 2025/8/28.
//

#import "HMAlbumCollectionViewCell.h"

@implementation HMAlbumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIsVideo:(NSInteger)isVideo
{
    _isVideo = isVideo;
}
- (void)setIsEidtPage:(NSInteger)isEidtPage
{
    _isEidtPage = isEidtPage;
}
- (void)setModel:(HMAlbumListModel *)model
{
    _model = model;
    self.statusLabel.alpha = self.deleteBtn.alpha = self.isEidtPage == YES ? 1 : 0;
    if ([model isKindOfClass:[HMAlbumListModel class]]) {
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:MPImage(@"")];
        self.statusLabel.alpha = [model.audit isEqualToString:@"Y"] ? 0 : 1;
        if ([model.audit isEqualToString:@"N"]) {
            self.statusLabel.text = [NSString stringWithFormat:@"(%@)",Localized(@"审核中")];
        }else if ([model.audit isEqualToString:@"R"]){
            self.statusLabel.text = [NSString stringWithFormat:@"(%@)",Localized(@"审核不通过")];
        }
    }else if ([model isKindOfClass:[UIImage class]]){
        [self.imgIcon setImage:(UIImage*)model];
    }
}

- (void)setVideoModel:(HMVideoListModel *)videoModel
{
    _videoModel = videoModel;
    self.playImg.alpha = 1;
    self.statusLabel.alpha = self.deleteBtn.alpha = self.isEidtPage == YES ? 1 : 0;
    if ([videoModel isKindOfClass:[HMVideoListModel class]]) {
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:videoModel.thumbnailUrl] placeholderImage:MPImage(@"")];
        self.statusLabel.alpha = [videoModel.audit isEqualToString:@"Y"] ? 0 : 1;
        if ([videoModel.audit isEqualToString:@"N"]) {
            self.statusLabel.text = [NSString stringWithFormat:@"(%@)",Localized(@"审核中")];
        }else if ([videoModel.audit isEqualToString:@"R"]){
            self.statusLabel.text = [NSString stringWithFormat:@"(%@)",Localized(@"审核不通过")];
        }
    }else if ([videoModel isKindOfClass:[NSDictionary class]]){
        NSDictionary * dd = (NSDictionary *)videoModel;
        [self.imgIcon setImage:dd[@"img"]];
    }
    if (self.isEidtPage) {
        self.playImg.alpha = !self.statusLabel.alpha;
    }
}

- (IBAction)deleteBtnAction:(id)sender {
    WeakSelf(self)
    if (self.isVideo) {
        if ([self.videoModel isKindOfClass:[HMVideoListModel class]]) {
            [PGAPIService deleteVideoAtVideoWithParameters:@{@"videoid":@(self.videoModel.videoid)} Success:^(id  _Nonnull data) {
                if (weakself.deleteImgBlock) {
                    weakself.deleteImgBlock();
                }
            } failure:^(NSInteger code, NSString * _Nonnull message) {
                
            }];
        }else if ([self.videoModel isKindOfClass:[NSDictionary class]]){
            if (self.deleteImgBlock) {
                self.deleteImgBlock();
            }
        }
    }else{
        if ([self.model isKindOfClass:[HMAlbumListModel class]]) {
            [PGAPIService deletePhotoAtAlbumWithParameters:@{@"photoId":self.model.photoid} Success:^(id  _Nonnull data) {
                if (weakself.deleteImgBlock) {
                    weakself.deleteImgBlock();
                }
            } failure:^(NSInteger code, NSString * _Nonnull message) {
                
            }];
        }else if ([self.model isKindOfClass:[UIImage class]]){
            if (self.deleteImgBlock) {
                self.deleteImgBlock();
            }
        }
    }
}

@end
