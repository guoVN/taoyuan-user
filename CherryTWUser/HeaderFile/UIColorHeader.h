//
//  UIColorHeader.h
//  CherryTWUser
//
//  Created by guo on 2024/4/8.
//

#ifndef UIColorHeader_h
#define UIColorHeader_h

#import "UIColor+Helper.h"

#define RGB(R,G,B)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:1.0]
#define RGBAlpha(R,G,B,A)  [UIColor colorWithRed:(R * 1.0) / 255.0 green:(G * 1.0) / 255.0 blue:(B * 1.0) / 255.0 alpha:A]
#define HEX(_hex_) [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#define HEXAlpha(_hex_,y) [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_)) alpha:y]

#define UUWhite HEX(#FFFFFF)
#define THEAME_COLOR HEX(#FF6796)

#define MPFont(x) [UIFont systemFontOfSize:x]
#define MPBoldFont(x) [UIFont boldSystemFontOfSize:x]
#define MPLightFont(size)  [UIFont systemFontOfSize:(size) weight:UIFontWeightLight]
#define MPMediumFont(size)  [UIFont systemFontOfSize:(size) weight:UIFontWeightMedium]
#define MPHeavyFont(size)   [UIFont systemFontOfSize:(size) weight:UIFontWeightHeavy]
#define MPSemiboldFont(size)   [UIFont systemFontOfSize:(size) weight:UIFontWeightSemibold]

#define MPImage(key) [UIImage imageNamed:key]

#endif /* UIColorHeader_h */
