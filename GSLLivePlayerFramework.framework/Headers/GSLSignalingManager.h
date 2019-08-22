//
//  GSLSignalingManager.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 GSLSignaling能力管理器
 */

#import "GSLLPObject.h"
#import "GSLSignalingProtocal.h"
#if __has_include(<GSLSignalingCenterFramework/GSLSignalingCenter.h>)
#import <GSLSignalingCenterFramework/GSLSignalingCenter.h>
#import <GSLSignalingCenterFramework/GSLSignalingCenterDelegate.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface GSLSignalingManager : GSLLPObject<GSLSignalingProtocal>

#if __has_include(<GSLSignalingCenterFramework/GSLSignalingCenter.h>)

// 请使用 +initWithAppId:token: 方法
+ (instancetype)new  __attribute__((unavailable("Use -initWithAppId:roomId:userId:token: instead")));
- (instancetype)init __attribute__((unavailable("Use -initWithAppId:roomId:userId:token: instead")));

@property (nonatomic, strong, readonly) GSLSignalingCenter *signalingCenter;

- (instancetype)initWithAppId:(NSString *)appId
                       roomId:(NSString *)roomId
                       userId:(NSString *)userId
                        token:(NSString *)token
                        error:(NSError **)error;

#endif

@end

NS_ASSUME_NONNULL_END
