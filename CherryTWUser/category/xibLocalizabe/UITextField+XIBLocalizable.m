//
//  UITextField+XIBLocalizable.m
//  MPCEnergy
//
//  Created by guo on 2023/6/1.
//

#import "UITextField+XIBLocalizable.h"
#import "NSString+Localize.h"
#import <objc/runtime.h>

@implementation UITextField (XIBLocalizable)

-(void)setXibLocplaceHKey:(NSString *)xibLocplaceHKey{
    self.placeholder = xibLocplaceHKey.localized;
}

-(NSString *)xibLocplaceHKey{
    return nil;
}

@end
