//
//  PGColorfulQRCodeView.h
//  CherryTWUser
//
//  Created by guo on 2024/12/10.
//  Copyright © 2024 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGColorfulQRCodeView : UIView

- (void)syncFrame;
- (void)setQRCodeImage:(UIImage *)qrcodeImage;
@property (nonatomic, strong) NSArray * colors;

@end

NS_ASSUME_NONNULL_END
