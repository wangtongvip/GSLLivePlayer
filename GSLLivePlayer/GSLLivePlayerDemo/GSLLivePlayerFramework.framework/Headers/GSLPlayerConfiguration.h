//
//  GSLPlayerConfiguration.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/16.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 SDK初始化参数
 */

#import "GSLLPObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSLPlayerConfiguration : GSLLPObject

/// 应用ID
@property (nonatomic, copy) NSString *appId;

/// 直播ID
@property (nonatomic, copy) NSString *liveId;

/// 房间ID
@property (nonatomic, copy) NSString *roomId;

/// 用户签名
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
