//
//  QMUITextView+XIBLocalizabe.m
//  MPCEnergy
//
//  Created by guo on 2023/6/1.
//

#import "QMUITextView+XIBLocalizabe.h"
#import "NSString+Localize.h"
#import <objc/runtime.h>

@implementation QMUITextView (XIBLocalizabe)

-(void)setXibLocplaceHKey:(NSString *)xibLocplaceHKey{
    self.placeholder = xibLocplaceHKey.localized;
}

-(NSString *)xibLocplaceHKey{
    return nil;
}

@end
