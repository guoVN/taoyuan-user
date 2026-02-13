//
//  UILabel+XIBLocalizable.m
//  MPCEnergy
//
//  Created by guo on 2023/6/1.
//

#import "UILabel+XIBLocalizable.h"
#import "NSString+Localize.h"
#import <objc/runtime.h>

@implementation UILabel (XIBLocalizable)

- (void)setXibLocKey:(NSString *)xibLocKey
{
    self.text = xibLocKey.localized;
}

- (NSString *)xibLocKey
{
    return nil;
}

@end
