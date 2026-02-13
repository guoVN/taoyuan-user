//
//  PGPublishDynamicCollectionViewCell.m
//  CherryTWUser
//
//  Created by guo on 2024/12/5.
//  Copyright © 2024 guo. All rights reserved.
//

#import "PGPublishDynamicCollectionViewCell.h"

@implementation PGPublishDynamicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteBtnAction:(id)sender {
    if (self.deleteImgBlock) {
        self.deleteImgBlock();
    }
}

@end
