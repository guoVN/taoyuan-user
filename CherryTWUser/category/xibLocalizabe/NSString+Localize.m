//
//  NSString+Localize.m
//  MPCEnergy
//
//  Created by guo on 2023/6/1.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localized{
    return NSLocalizedString(self, nil);
}

@end
