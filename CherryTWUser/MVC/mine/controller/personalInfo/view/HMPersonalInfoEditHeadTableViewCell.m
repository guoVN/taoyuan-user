//
//  HMPersonalInfoEditHeadTableViewCell.m
//  CherryTWanchor
//
//  Created by guo on 2025/8/27.
//

#import "HMPersonalInfoEditHeadTableViewCell.h"

@interface HMPersonalInfoEditHeadTableViewCell ()

@end

@implementation HMPersonalInfoEditHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[PGManager shareModel].userInfo.photo]];
    [self.headImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgClick)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)headImgClick
{
    WeakSelf(self)
    [[PGManager shareModel] chooseMediaWith:1 count:1 withCrop:NO selectImg:^(NSArray *imgArr) {
         UIImage * headIcon = imgArr.firstObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.headImg setImage:headIcon];
        });
        [weakself updateHeadImg:headIcon];
    } selectVideo:^(UIImage *coverImg, NSURL *videoUrl) {
    }];
}

- (void)updateHeadImg:(UIImage *)headIcon
{
    WeakSelf(self)
    if (self.headImg.image != nil) {
        [QMUITips showLoading:@"头像上传中" inView:[PGUtils getCurrentVC].view];
        [PGAPIService uploadFileWithImages:@[headIcon] Success:^(id  _Nonnull data) {
//            [QMUITips hideAllTips];
            NSArray * imgDataArr = data[@"data"];
            NSMutableArray * photoArr = [NSMutableArray array];
            for (NSString * str in imgDataArr) {
                [photoArr addObject:str];
            }
            [weakself shumeiCheck:[photoArr componentsJoinedByString:@","]];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:@"上传失败"];
        }];
    }
}
- (void)shumeiCheck:(NSString *)headStr
{
    WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@"IMAGE" forKey:@"eventId"];
    [dic setValue:headStr forKey:@"img"];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [PGAPIService shumeiImgCheckWithParameters:dic Success:^(id  _Nonnull data) {
//        [QMUITips hideAllTips];
        [weakself goUpdateAction:headStr];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        [QMUITips hideAllTips];
        [QMUITips showWithText:message];
    }];
}
- (void)goUpdateAction:(NSString *)urlStr
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:urlStr forKey:@"photo"];
     [PGAPIService updateHeadImgWithParameters:dic Success:^(id  _Nonnull data) {
         [QMUITips hideAllTips];
     } failure:^(NSInteger code, NSString * _Nonnull message) {
         [QMUITips hideAllTips];
         [QMUITips showWithText:message];
     }];
}

@end
