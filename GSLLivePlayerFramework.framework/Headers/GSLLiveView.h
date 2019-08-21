//
//  GSLLiveView.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 视频渲染承载视图
 */

#import "GSLLPView.h"
#import "GSLLivePlayerDef.h"

@class GSLLivePlayer;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GSLLiveViewUserType) {
    GSLLiveViewUserType_Anchor   = 0,  ///< 主播
    GSLLiveViewUserType_Audience = 1,  ///< 观众
    GSLLiveViewUserType_Assist   = 2,  ///< 辅助流
};

@interface GSLLiveView : GSLLPView

// 请使用 -initWithUserId: 方法
+ (instancetype)new  __attribute__((unavailable("Use -initWithUserId: instead")));
- (instancetype)init __attribute__((unavailable("Use -initWithUserId: instead")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("Use -initWithUserId: instead")));

/**
 初始化承载视频的视图载体
 
 @param userId 用户 ID
 @return 承载视频的视图载体
 */
- (instancetype)initWithUserId:(NSString *)userId userType:(GSLLiveViewUserType)userType livePlayer:(GSLLivePlayer *)player;

/**
 画面承载的视频是否是当前用户的
 */
@property (nonatomic, assign, readonly) BOOL isCurrentUser;

/**
 当前画面对应的用户ID
 */
@property (nonatomic, copy, readonly) NSString *userId;

/**
 用户类型
 */
@property (nonatomic, assign, readonly) GSLLiveViewUserType userType;

/**
 画面填充模式
 */
@property (nonatomic, assign) GSLLiveVideoFillMode fillMode;

/**
 停止显示画面
 
 @note 对辅助流无效
 @note banVideo的优先级大于muteVideo。只有在banVideo为NO的情况下，muteVideo才生效
 */
@property (nonatomic, assign) BOOL muteVideo;

/**
 停止播放声音
 
 @note 对辅助流无效
 @note banAudio的优先级大于muteAudio。只有在banAudio为NO的情况下，muteAudio才生效
 */
@property (nonatomic, assign) BOOL muteAudio;

/**
 禁画状态
 
 @note 对辅助流无效
 */
@property (nonatomic, assign) BOOL banVideo;

/**
 禁音状态
 
 @note 对辅助流无效
 */
@property (nonatomic, assign) BOOL banAudio;

/**
 禁画回调
 
 @note 对辅助流无效
 */
@property (nonatomic, copy) void(^onBanVideo)(GSLLiveView *liveView, BOOL ban);

/**
 禁音回调
 
 @note 对辅助流无效
 */
@property (nonatomic, copy) void(^onBanAudio)(GSLLiveView *liveView, BOOL ban);

/**
 视频质量回调
 
 @note 对辅助流无效
 */
@property (nonatomic, copy) void(^onVideoQualityChanged)(GSLLiveView *liveView, GSLLiveQuality videoQuality);

/**
 说话者的音量回调
 
 @note 对辅助流无效
 @note 取值范围0 - 100
 */
@property (nonatomic, copy) void(^onAudioQualityChanged)(GSLLiveView *liveView, float AudioQuality);

@end

NS_ASSUME_NONNULL_END
