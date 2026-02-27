//
//  HMIntimacyListModel.h
//  CherryTWanchor
//
//  Created by guo on 2025/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMIntimacyListModel : NSObject

@property (nonatomic, copy) NSString * anchorId;
@property (nonatomic, copy) NSString * anchorNickName;
@property (nonatomic, copy) NSString * anchorPhoto;
@property (nonatomic, copy) NSString * intimacy;
@property (nonatomic, assign) NSInteger intimacyLevel;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * userid;

@end

NS_ASSUME_NONNULL_END
