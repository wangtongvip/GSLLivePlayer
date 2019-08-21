//
//  GSLLivePlayer.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

//  version 1.1.1
//  base TRTC v6.6.7459

/**
 高思云视频通话功能的主要接口类
 */

#import "GSLLPObject.h"
#import "GSLLivePlayerDelegate.h"
#import "GSLLiveView.h"
#import "GSLSignalingProtocal.h"
#import "GSLPlayerConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSLLivePlayer : GSLLPObject

// 请使用 +sharedIntance 方法
+ (instancetype)new  __attribute__((unavailable("Use +sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("Use +sharedInstance instead")));

/////////////////////////////////////////////////////////////////////////////////
//
//                      SDK 基础函数
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark - SDK 基础函数

/**
 获取当前SDK版本号
 
 @return 版本号
 */
+ (NSString *)version;

/**
 创建 GSLLivePlayer 单例
 
 @return GSLLivePlayer 单例
 */
+ (instancetype)sharedInstance;

/**
 调试时是否需要打印调试信息
 
 @param open YES：打印 | NO：不打印
 */
+ (void)openDebugLogInfo:(BOOL)open;

/**
 销毁 GSLLivePlayer 单例
 */
+ (void)destroySharedIntance;

/**
 设置回调接口 GSLLivePlayerDelegate
 
 @note 您也可以通过事件回调的block获取回调信息
 */
@property (nonatomic, assign) id <GSLLivePlayerDelegate> delegate;

/**
 信令管理器
 */
@property (nonatomic, strong) id <GSLSignalingProtocal> signalingManager;

/**
 配置播放器的参数，只有在配置参数并且回调成功后，才能进房，否则进房会失败
 
 @param configuration 初始化参数
 @param success 初始化成功的回调
 @param failure 初始化失败的回调
 */
- (void)configurePlayerWithConfiguration:(GSLPlayerConfiguration *)configuration
                                 success:(void (^)(NSString *liveUserId))success
                                 failure:(void (^)(NSError *ERROR))failure;


/////////////////////////////////////////////////////////////////////////////////
//
//                      SDK 基础属性
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark - SDK 基础函数


/**
 直播时的当前用户Id
 */
@property (nonatomic, strong, readonly) NSString *userId;

/**
 辅助视图
 
 @note 辅助视图目前是主播端的屏幕分享等辅助视图窗口
 @note 用户可以根据需要布局辅助视图位置，视图默认填充完整的父视图。空缺处是黑色留白
 */
@property (nonatomic, strong, readonly) GSLLiveView *assistView;

/**
 主播的视图
 */
@property (nonatomic, strong, readonly) GSLLiveView *anchorView;

/**
 远端视频的集合
 
 @note 所有连麦观众的视图集合
 @note 当前用户或远端用户连麦后，会加入此数组
 @note 当当前用户或远端视频加入断开时此数组刷新
 @note 此数组的加入和移除，必须通过调用以下方法才会维护
        - (void)startLocalView:(BOOL)frontCamera view:(nonnull GSLLiveView *)view;
        - (void)stopLocalView;
        - (void)startRemoteView:(NSString *)userId view:(nonnull GSLLiveView *)view;
        - (void)stopRemoteView:(NSString *)userId;
 */
@property (nonatomic, strong, readonly) NSMutableArray<GSLLiveView *> *remoteViews;

/**
 通过userId找到remoteViews中对应的view
 
 @return 找到的视图，找不到返回nil
 */
- (GSLLiveView *)getCacheRemoteViewWithUserId:(NSString *)userId;

/**
 
 @note 进房之前设置
 
 @note 远端视频链接上后在 remoteViews 的排列顺序
 */
@property (nonatomic, assign) GSLLiveRemoteOrder remoteOrder;

/**
 当前用户的连麦状态
 */
@property (nonatomic, assign, readonly) GSLLiveLinkStatus linkStatus;

/** TODO 目前禁音禁画暴露给业务方处理，这个状态理论上可以交由业务方，SDK可以不做处理
 当前用户的禁画状态
 */
@property (nonatomic, assign, readonly) GSLLiveBanVideoStatus banVideoStatus;

/** TODO 目前禁音禁画暴露给业务方处理，这个状态理论上可以交由业务方，SDK可以不做处理
 当前用户的禁音状态
 */
@property (nonatomic, assign, readonly) GSLLiveBanAudioStatus banAudioStatus;

/**
 当前服务器连接状态
 */
@property (nonatomic, assign, readonly) GSLLiveConnectStatus connectStatus;


/////////////////////////////////////////////////////////////////////////////////
//
//                      （一）房间相关接口函数
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark - 房间相关接口函数

/**
 进入房间
 
 @note 需要在配置播放器成功后才可调用此方法。配置播放器：-(void)configurePlayerWithConfiguration: success: failure: ;
 */
- (void)enterRoom;

/**
 离开房间
 */
- (void)exitRoom;


/////////////////////////////////////////////////////////////////////////////////
//
//                      （二）视频相关接口函数
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark - 视频相关接口函数

/**
 打开本地视频预览
 
 @note 打开本地预览后，对方无法看到你的画面，只有调用startLocalView:view:方法后才真正推流，其他人才能看到你的画面
 
 @param frontCamera YES：前置摄像头；NO：后置摄像头
 @param view 承载视频画面的控件
 */
- (void)startLocalPreview:(BOOL)frontCamera view:(nonnull UIView *)view;

/**
 停止本地视频预览
 */
- (void)stopLocalPreview;

/**
 展示本地视频并将流推向远端
 
 @note 调用此方法后，remoteViews这个属性中就会维护这个画面

 @param frontCamera YES：前置摄像头；NO：后置摄像头
 @param view 承载视频画面的控件
 */
- (void)startLocalView:(BOOL)frontCamera view:(nonnull GSLLiveView *)view;

/**
 停止本地视频并结束推送画面
 
 @note 调用此方法后，remoteViews这个属性中就会移除这个视频画面
 */
- (void)stopLocalView;

/**
 开始显示远端视频画面
 
 @note 在收到 SDK 的 onAudienceAvailable 回调时，调用这个接口，就可以显示远端视频的画面了。
 @note 调用此方法后，remoteViews这个属性中就会维护这个视频画面。
 
 @param userId 对方的用户标识
 @param view 承载视频画面的控件
 */
- (void)startRemoteView:(NSString *)userId view:(nonnull GSLLiveView *)view;

/**
 停止显示远端视频画面
 
 @note 调用此方法后，remoteViews这个属性中就会移除这个视频画面
 
 @param userId 对方的用户标识
 */
- (void)stopRemoteView:(NSString *)userId;

/**
 开始显示远端用户的辅助画面

 @note 在收到 SDK 的 onAssistAvailable 回调时，调用这个接口，就可以显示远端视频的画面了。
 @note 调用此方法后，assistView这个属性中已经存在远端视频画面。
 
 @param userId 对方的用户标识
 @param view 渲染控件
 */
- (void)startRemoteSubStreamView:(NSString *)userId view:(nonnull GSLLiveView *)view;

/**
 停止显示远端用户的辅助画面
 
 @note 调用此方法后，assistView这个属性就会移除视频画面，此属性置为nil

 @param userId 对方的用户标识
 */
- (void)stopRemoteSubStreamView:(NSString *)userId;

/**
 屏蔽本地视频采集
 
 @note 远端用户显示的画面会停留在最后一帧
 
 @param mute 是否屏蔽本地画面采集 YES：屏蔽 | NO：打开
 */
- (void)muteLocalVideo:(BOOL)mute;

/**
 静音掉某一个远端用户的视频
 
 @param userId userId 对方的用户 ID
 @param mute YES：静画；NO：非静画
 */
- (void)muteRemoteVideo:(NSString *)userId mute:(BOOL)mute;

/** 
 静音掉所有远端用户的视频
 
 @param mute YES：静画；NO：非静画
 */
- (void)muteAllRemoteVideo:(BOOL)mute;

/**
 设置本地图像的填充模式
 
 @param mode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边）
 */
- (void)setLocalViewFillMode:(GSLLiveVideoFillMode)mode;

/**
 设置远端图像的填充模式
 
 @param userId 用户 ID
 @param mode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边）
 */
- (void)setRemoteViewFillMode:(NSString*)userId mode:(GSLLiveVideoFillMode)mode;

/**
 设置辅助画面的显示模式

 @param userId 用户的 ID
 @param mode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边）
 */
- (void)setRemoteSubStreamViewFillMode:(NSString *)userId mode:(GSLLiveVideoFillMode)mode;

/**
 设置上行视频画面质量和屏幕方向
 
 @note 此方法需要在进房成功后（onEnterRoom）设置才会生效
 @note 建议在屏幕旋转时判断需要推送的是横屏画面或竖屏画面，然后设置相应的横竖屏画面质量方式。判断controller的横竖屏可以使用以下方法：
 - (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;
 
 @param param 配置参数
 */
- (void)setVideoQosParam:(GSLLiveVideoQosParam *)param;

/**
 设置网络流控策略
 
 @param param 网络流控策略，详情请参考 GSLRTCCloudDef.h 中的 GSLRTCVideoQosPreference 定义
 */
- (void)setNetworkQosParam:(GSLLiveVideoQosPreference)param;


/////////////////////////////////////////////////////////////////////////////////
//
//                      （三）音频相关接口函数
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark - 音频相关接口函数

/**
 开启本地音频的采集和上行
 
 @note 该函数会检查麦克风的使用权限，如果当前 App 没有麦克风权限，SDK 会向用户申请开启。
 
 该函数会启动麦克风采集，并将音频数据传输给房间里的其他用户。
 SDK 并不会默认开启本地的音频上行，也就说，如果您不调用这个函数，房间里的其他用户就听不到您的声音。
 */
- (void)startLocalAudio;

/**
 关闭本地音频的采集和上行
 */
- (void)stopLocalAudio;

/**
 静音本地的音频
 
 @note 与 stopLocalAudio 不同之处在于，muteLocalAudio 并不会停止发送音视频数据，而是会继续发送码率极低的静音包，比简单粗暴地停止
 
 @param mute YES：屏蔽；NO：开启
 */
- (void)muteLocalAudio:(BOOL)mute;

/**
 静音掉某一个用户的声音
 
 @param userId 对方的用户 ID
 @param mute  YES：静音；NO：非静音
 */
- (void)muteRemoteAudio:(NSString *)userId mute:(BOOL)mute;

/**
 静音掉所有远端用户的声音
 
 @param mute YES：静音；NO：非静音
 */
- (void)muteAllRemoteAudio:(BOOL)mute;


/////////////////////////////////////////////////////////////////////////////////
//
//                      （四）硬件相关接口函数
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark - 硬件相关接口函数

/**
 切换摄像头
 */
- (void)switchCamera;

/**
 切换预览摄像头
 */
- (void)switchPreviewCamera;

/////////////////////////////////////////////////////////////////////////////////
//
//                      （五）用户行为相关接口函数
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark - 用户行为相关接口函数

/**
 申请连麦
 */
- (void)applyConnectToAnchor;

/**
 同意连麦
 */
- (void)agreeConnectToAnchor;

/**
 拒绝连麦
 */
- (void)refuseConnectToAnchor;

/**
 用户断开连麦
 */
- (void)disConnectToAnchor;

#pragma mark-
#pragma mark- 事件回调
#pragma mark-

/////////////////////////////////////////////////////////////////////////////////
//
//                      （六）系统事件回调
// @note 以下的block回调，也可通过 GSLLivePlayerDelegate 代理的方式进行实现，功能完全一致
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 系统事件回调

/**
 错误回调：SDK 不可恢复的错误，一定要监听，并分情况给用户适当的界面提示。
 
 @param errorCode 错误码
 @param extErrorCode 扩展错误码
 @param errorMessage 错误信息
 @param extInfo 扩展信息字段，个别错误码可能会带额外的信息帮助定位问题
 */
@property (nonatomic, copy) void(^onError)(GSLLivePlayer *player, GSLLiveErrorCode errorCode, NSInteger extErrorCode, NSString *_Nullable errorMessage, NSDictionary *_Nullable extInfo);

/**
 警告回调：用于告知您一些非严重性问题，比如出现了卡顿或者可恢复的解码失败。
 
 @param warningCode 警告码
 @param extWarningCode 扩展警告码
 @param warningMessage 警告信息
 @param extInfo 扩展信息字段，个别警告码可能会带额外的信息帮助定位问题
 */
@property (nonatomic, copy) void(^onWarning)(GSLLivePlayer *player, GSLLiveWarningCode warningCode, NSInteger extWarningCode, NSString *_Nullable warningMessage, NSDictionary *_Nullable extInfo);


/////////////////////////////////////////////////////////////////////////////////
//
//                      （七）当前用户事件回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 当前用户事件回调

/**
 加入房间
 */
@property (nonatomic, copy) void(^onEnterRoom)(GSLLivePlayer *player);

/**
 离开房间
 */
@property (nonatomic, copy) void(^onExitRoom)(GSLLivePlayer *player);

/**
 收到连麦邀请
 */
@property (nonatomic, copy) void(^onInviteConnectToAnchor)(GSLLivePlayer *player);

/**
 连麦申请被同意
 
 @param banVideo 是否被禁画
 @param banAudio 是否被禁音
 */
@property (nonatomic, copy) void(^onAgreeConnectToAnchor)(GSLLivePlayer *player, BOOL banVideo, BOOL banAudio);

/**
 连麦申请被拒绝
 */
@property (nonatomic, copy) void(^onRefuseConnectToAnchor)(GSLLivePlayer *player);

/**
 被禁画/解禁
 
 @param banVideo YES：禁音 | NO：解禁
 */
@property (nonatomic, copy) void(^onBanVideo)(GSLLivePlayer *player, BOOL banVideo);

/**
 被禁音/解禁
 
 @param banAudio YES：禁音 | NO：解禁
 */
@property (nonatomic, copy) void(^onBanAudio)(GSLLivePlayer *player, BOOL banAudio);

/**
 失去和主播的连接
 
 @note 这里是被动失去，主播端主动断开连接
 */
@property (nonatomic, copy) void(^onDisconnectToAnchor)(GSLLivePlayer *player);

/////////////////////////////////////////////////////////////////////////////////
//
//                      （八）远端用户事件回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 远端用户事件回调

/**
 辅助画面可展示或消失
 
 @param available YES：可展示 | NO：消失
 @param userId 辅助画面用户编号，同 用户的ID
 */
@property (nonatomic, copy) void(^onAssistAvailable)(GSLLivePlayer *player, BOOL available, NSString *userId);

/**
 主播可展示或消失
 
 @param available YES：可展示 | NO：消失
 @param userId 主播的用户 ID
 */
@property (nonatomic, copy) void(^onAnchorAvailable)(GSLLivePlayer *player, BOOL available, NSString *userId);

/**
 有远端用户可展示或消失
 
 @param available YES：可展示 | NO：消失
 @param userId 远端用户的用户 ID
 @param banVideo 是否被禁画
 @param banAudio 是否被禁音
 */
@property (nonatomic, copy) void(^onAudienceAvailable)(GSLLivePlayer *player, BOOL available, NSString *userId, BOOL banVideo, BOOL banAudio);

/**
 有用户被禁画/解禁
 
 @param banVideo YES：禁画 | NO：解禁
 @param userId 远端用户的用户 ID
 */
@property (nonatomic, copy) void(^onAudienceBanVideo)(GSLLivePlayer *player, BOOL banVideo, NSString *userId);

/**
 有用户被禁音/解禁
 
 @param banAudio YES：禁音 | NO：解禁
 @param userId 远端用户的用户 ID
 */
@property (nonatomic, copy) void(^onAudienceBanAudio)(GSLLivePlayer *player, BOOL banAudio, NSString *userId);

/////////////////////////////////////////////////////////////////////////////////
//
//                      （九）质量参数回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 质量参数回调

/**
 网络质量：该回调每2秒触发一次，统计当前网络的上行和下行质量
 
 @note userId == nil 代表自己当前的视频质量
 
 @param localQuality 上行网络质量
 @param remoteQuality 下行网络质量
 */
@property (nonatomic, copy) void(^onNetworkQuality)(GSLLivePlayer *player, GSLLiveQualityInfo *_Nullable localQuality, NSArray<GSLLiveQualityInfo *> *_Nullable remoteQuality);

/**
 用于提示音量大小的回调,包括每个 userId 的音量和远端总音量
 
 @note 该回调每300ms秒触发一次，统计当前网络的上行和下行质量
 
 @param userVolumes userVolumes 所有正在说话的房间成员的音量（取值范围0 - 100）。即 userVolumes 内仅包含音量不为0（正在说话）的用户音量信息。
 @param totalVolume totalVolume 所有远端成员的总音量, 取值范围0 - 100
 */
@property (nonatomic, copy) void(^onUserVoiceVolume)(GSLLivePlayer *player, NSArray<GSLLiveVolumeInfo *> *_Nullable userVolumes, NSInteger totalVolume);

/////////////////////////////////////////////////////////////////////////////////
//
//                      （十）服务器状态回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 服务器状态回调

/**
 服务器连接状态改变
 
 @param connectStatus 服务器连接状态
 */
@property (nonatomic, copy) void(^onServerConnectStatusChange)(GSLLivePlayer *player, GSLLiveConnectStatus connectStatus);

@end

NS_ASSUME_NONNULL_END
