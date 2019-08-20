//
//  SettingManager.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/25.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingManager : NSObject

@property (nonatomic, copy) NSString *livePlayer_appId;
@property (nonatomic, copy) NSString *livePlayer_liveId;
@property (nonatomic, copy) NSString *livePlayer_roomId;
@property (nonatomic, copy) NSString *livePlayer_userId;
@property (nonatomic, copy) NSString *livePlayer_token;

+ (id)shareManager;

@end

NS_ASSUME_NONNULL_END
