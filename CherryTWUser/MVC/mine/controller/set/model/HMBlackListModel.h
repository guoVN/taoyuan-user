//
//  HMBlackListModel.h
//  CherryTWanchor
//
//  Created by guo on 2025/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMBlackListModel : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString * anchorName;
@property (nonatomic, assign) NSInteger anchorid;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, assign) NSInteger targetid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, assign) NSInteger userid;

@end

NS_ASSUME_NONNULL_END
