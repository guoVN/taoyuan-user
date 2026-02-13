//
//  PGEditHeadTableViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/6.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGEditHeadTableViewCell.h"
#import "TZImagePickerHelper.h"

@interface PGEditHeadTableViewCell ()

@property (nonatomic, strong) TZImagePickerHelper * helper;

@end

@implementation PGEditHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)chooseImgAction:(id)sender {
    [self.helper showImagePickerControllerWithMaxCount:1 WithViewController:[PGUtils getCurrentVC]];
}

- (TZImagePickerHelper *)helper {
    if (!_helper) {
        _helper = [[TZImagePickerHelper alloc] init];
         WeakSelf(self)
        _helper.finish = ^(NSArray *array){
            for (int i = 0; i< array.count; i++) {
                UIImage *image = [UIImage imageWithContentsOfFile:array[i]];
                NSData *data=UIImageJPEGRepresentation(image,1.0f);
                if (data != nil) {
                    if ([data length]>2*1024*2014) {
                        data = [PGUtils resetSizeOfImageData:[UIImage imageWithData:data] maxSize:2048];
                    }
                    image = [UIImage imageWithData:data];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.headImg setImage:image];
                    [weakself updateHeadImg];
                });
            }
        };
    }
    return _helper;
}

- (void)updateHeadImg
{
    WeakSelf(self)
    if (self.headImg.image != nil) {
        [QMUITips showLoading:@"头像上传中" inView:[PGUtils getCurrentVC].view];
        [PGAPIService uploadFileWithImages:@[self.headImg.image] Success:^(id  _Nonnull data) {
            [QMUITips hideAllTips];
            NSString * headImgStr = data[@"data"];
            [weakself goUpdateAction:headImgStr];
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            [QMUITips hideAllTips];
            [QMUITips showWithText:@"上传失败"];
        }];
    }
}
- (void)goUpdateAction:(NSString *)urlStr
{
     WeakSelf(self)
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
    [dic setValue:urlStr forKey:@"photo"];
     [PGAPIService updateHeadImgWithParameters:dic Success:^(id  _Nonnull data) {
         if (weakself.updateHeadBlock) {
             weakself.updateHeadBlock();
         }
     } failure:^(NSInteger code, NSString * _Nonnull message) {
         [QMUITips showWithText:message];
     }];
}

@end
