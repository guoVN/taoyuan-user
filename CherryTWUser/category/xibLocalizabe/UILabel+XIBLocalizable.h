//
//  UILabel+XIBLocalizable.h
//  MPCEnergy
//
//  Created by guo on 2023/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XIBLocalizable)

@property (nonatomic, copy)IBInspectable NSString *xibLocKey;

@end

NS_ASSUME_NONNULL_END
