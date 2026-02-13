//
//  UIButton+XIBLocalizable.m
//  MPCEnergy
//
//  Created by guo on 2023/6/1.
//

#import "UIButton+XIBLocalizable.h"
#import "NSString+Localize.h"
#import <objc/runtime.h>

@implementation UIButton (XIBLocalizable)

-(void)setXibLocKey:(NSString *)xibLocKey{
    [self setTitle:xibLocKey.localized forState:UIControlStateNormal];
}

-(NSString *)xibLocKey{
    return nil;
}

@end
