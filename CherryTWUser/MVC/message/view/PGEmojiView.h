//
//  PGEmojiView.h
//  CherryTWUser
//
//  Created by guo on 2025/1/5.
//  Copyright © 2025 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CherryTWUser-swift.h"
#import <MCEmojiPicker-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGEmojiView : UIView

@property (nonatomic, strong) MCEmojiPickerViewController * pickerVC;

@end

NS_ASSUME_NONNULL_END
