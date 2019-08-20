//
//  GSLLivePlayerDelegate.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 GSLRTC事件回调代理
 */

#import <Foundation/Foundation.h>
#import "GSLLivePlayerDef.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GSLLivePlayerDelegate <NSObject>
@optional

/////////////////////////////////////////////////////////////////////////////////
//
//                      （一）SDK事件回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- SDK事件回调

/**
 错误回调：SDK 不可恢复的错误，一定要监听，并分情况给用户适当的界面提示。
 
 @param errorCode 错误码
 @param extErrorCode 扩展错误码
 @param errorMessage 错误信息
 @param extInfo 扩展信息字段，个别错误码可能会带额外的信息帮助定位问题
 */
- (void)onError:(GSLLiveErrorCode)errorCode extErrorCode:(NSInteger)extErrorCode errorMessage:(nullable NSString *)errorMessage extInfo:(nullable NSDictionary *)extInfo;

/**
 警告回调：用于告知您一些非严重性问题，比如出现了卡顿或者可恢复的解码失败。
 
 @param warningCode 警告码
 @param extWarningCode 扩展警告码
 @param warningMessage 警告信息
 @param extInfo 扩展信息字段，个别警告码可能会带额外的信息帮助定位问题
 */
- (void)onWarning:(GSLLiveWarningCode)warningCode extWarningCode:(NSInteger)extWarningCode warningMessage:(nullable NSString *)warningMessage extInfo:(nullable NSDictionary *)extInfo;


/////////////////////////////////////////////////////////////////////////////////
//
//                      （一）当前用户事件回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 当前用户事件回调

/**
 加入房间
 */
- (void)onEnterRoom;

/**
 离开房间
 */
- (void)onExitRoom;

/**
 收到连麦邀请
 */
- (void)onInviteConnectToAnchor;

/**
 连麦申请被同意
 
 @param banVideo 是否被禁画
 @param banAudio 是否被禁音
 */
- (void)onAgreeConnectToAnchorBanVideo:(BOOL)banVideo banAudio:(BOOL)banAudio;

/**
 连麦申请被拒绝
 */
- (void)onRefuseConnectToAnchor;

/**
 被禁画
 
 @param banVideo YES：禁画 | NO：解禁
 */
- (void)onBanVideo:(BOOL)banVideo;

/**
 被禁音
 
 @param banAudio YES：禁音 | NO：解禁
 */
- (void)onBanAudio:(BOOL)banAudio;

/**
 失去和主播的连接
 
 @note 这里是被动失去，主播端主动断开连接
 */
- (void)onDisconnectToAnchor;


/////////////////////////////////////////////////////////////////////////////////
//
//                      （二）远端用户事件回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 远端用户事件回调

/**
 辅助画面可展示或消失
 
 @param available YES：可展示 | NO：消失
 @param userId 辅助画面编号，同 用户的ID
 */
- (void)onAssistAvailable:(BOOL)available streamId:(nullable NSString *)userId;

/**
 主播可展示或消失
 
 @param available YES：可展示 | NO：消失
 @param userId 主播的用户 ID
 */
- (void)onAnchorAvailable:(BOOL)available userId:(nullable NSString *)userId;

/**
 有远端用户可展示或消失
 
 @param available YES：可展示 | NO：消失
 @param userId 远端用户的用户 ID
 @param banVideo 是否被禁画
 @param banAudio 是否被禁音
 */
- (void)onAudienceAvailable:(BOOL)available userId:(nullable NSString *)userId banVideo:(BOOL)banVideo banAudio:(BOOL)banAudio;

/**
 有用户被禁画/解禁
 
 @param banVideo YES：禁画 | NO：解禁
 @param userId 远端用户的用户 ID
 */
- (void)onAudienceBanVideo:(BOOL)banVideo userId:(nullable NSString *)userId;

/**
 有用户被禁音/解禁
 
 @param BanAudio YES：禁音 | NO：解禁
 @param userId 远端用户的用户 ID
 */
- (void)onAudienceBanAudio:(BOOL)BanAudio userId:(nullable NSString *)userId;

/////////////////////////////////////////////////////////////////////////////////
//
//                      （三）质量参数回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 质量参数回调

/**
 网络质量：该回调每2秒触发一次，统计当前网络的上行和下行质量
 
 @note userId == nil 代表自己当前的视频质量
 
 @param localQuality 上行网络质量
 @param remoteQuality 下行网络质量
 */
- (void)onNetworkQuality:(GSLLiveQualityInfo *_Nullable)localQuality remoteQuality:(NSArray<GSLLiveQualityInfo *> *_Nonnull)remoteQuality;

/**
 用于提示音量大小的回调,包括每个 userId 的音量和远端总音量
 
 @note 该回调每300ms秒触发一次，统计当前网络的上行和下行质量
 
 @param userVolumes userVolumes 所有正在说话的房间成员的音量（取值范围0 - 100）。即 userVolumes 内仅包含音量不为0（正在说话）的用户音量信息。其中 userId 为 null  表示 local 的音量，也就是自己的音量。
 @param totalVolume totalVolume 所有远端成员的总音量, 取值范围0 - 100
 */
- (void)onUserVoiceVolume:(NSArray<GSLLiveVolumeInfo *> *_Nullable)userVolumes totalVolume:(NSInteger)totalVolume;

/////////////////////////////////////////////////////////////////////////////////
//
//                      （四）服务器状态回调
//
/////////////////////////////////////////////////////////////////////////////////

#pragma mark- 服务器状态回调

/**
 服务器连接状态改变
 
 @param connectStatus 服务器连接状态
 */
- (void)onServerConnectStatusChange:(GSLLiveConnectStatus)connectStatus;

@end

NS_ASSUME_NONNULL_END
