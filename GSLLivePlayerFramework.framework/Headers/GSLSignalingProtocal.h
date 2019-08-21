//
//  GSLRTCSignalingProtocal.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 信令能力协议
 */

#import <Foundation/Foundation.h>
#import "GSLSignalingProtocal.h"

#define GSLSC_LINKING_USER_LIST_USER_ID  @"userId"           //用户编号
#define GSLSC_LINKING_USER_LIST_USER_ROLE  @"userRole"       //用户角色 1：主播 | 0：观众
#define GSLSC_LINKING_USER_LIST_CONNECT_TYPE  @"connectType" //连麦类型 0：未连麦 | 1：只连麦 | 2：只分享辅助画面 | 3：既连麦也分享辅助画面
#define GSLSC_LINKING_USER_LIST_MUTE_VIDEO  @"muteVideo"     //是否禁画 1：是 | 0：否
#define GSLSC_LINKING_USER_LIST_MUTE_AUDIO  @"muteAudio"     //是否禁音 1：是 | 0：否

NS_ASSUME_NONNULL_BEGIN

@protocol GSLSignalingProtocal <NSObject>

@required

/**
 销毁信令
 */
- (void)destroySignaling;

@optional

/////////////////////////////////////////////////////////////////////////////////
//
//                      （一）房间能力相关接口
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark- 房间能力相关接口

/**
 获取用户列表
 */
- (void)getSignalingUserList;

/////////////////////////////////////////////////////////////////////////////////
//
//                      （二）用户行为相关接口函数
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark- 用户行为相关接口函数

/**
 申请连麦
 
 @param anchorId 主播ID
 */
- (void)applyConnectToAnchor:(NSString *)anchorId;

/**
 同意连麦
 
 @param currentUserId 当前用户的ID
 */
- (void)agreeConnectToAnchor:(NSString *)currentUserId;

/**
 拒绝连麦
 
 @param currentUserId 当前用户的ID
 */
- (void)refuseConnectToAnchor:(NSString *)currentUserId;

/**
 用户断开连麦
 */
- (void)disConnectToAnchor;

#pragma mark-
#pragma mark- 事件回调
#pragma mark-

/////////////////////////////////////////////////////////////////////////////////
//
//                      （三）系统事件回调
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark- 系统事件回调

/**
 当前用户的列表
 
 @note 目前只有用户ID、禁音、禁画属性可以使用，其他属性暂时未生效
 
 @note 数组中字典key的含义：
 @note GSLSC_LINKING_USER_LIST_USER_ID                用户编号
 @note GSLSC_LINKING_USER_LIST_USER_ROLE          用户角色 1：主播 | 0：观众
 @note GSLSC_LINKING_USER_LIST_CONNECT_TYPE  连麦类型 0：未连麦 | 1：只连麦 | 2：只分享辅助画面 | 3：既连麦也分享辅助画面
 @note GSLSC_LINKING_USER_LIST_MUTE_VIDEO        是否禁画 1：是 | 0：否
 @note GSLSC_LINKING_USER_LIST_MUTE_AUDIO        是否禁音 1：是 | 0：否
 */
@property (nonatomic, copy) void(^onUserList)(id<GSLSignalingProtocal> signaling, NSArray<NSDictionary *> *userList);


/////////////////////////////////////////////////////////////////////////////////
//
//                      （四）当前用户事件回调
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark- 当前用户事件回调

/**
 收到连麦邀请
 */
@property (nonatomic, copy) void(^onInviteConnectToAnchor)(id<GSLSignalingProtocal> signaling);

/**
 连麦申请被同意
 */
@property (nonatomic, copy) void(^onAgreeConnectToAnchor)(id<GSLSignalingProtocal> signaling);

/**
 连麦申请被拒绝
 */
@property (nonatomic, copy) void(^onRefuseConnectToAnchor)(id<GSLSignalingProtocal> signaling);

/**
 被禁画/解禁
 
 @param mute YES：禁音 | NO：解禁
 */
@property (nonatomic, copy) void(^onBanVideo)(id<GSLSignalingProtocal> signaling, BOOL banVideo);

/**
 被禁音/解禁
 
 @param mute YES：禁音 | NO：解禁
 */
@property (nonatomic, copy) void(^onBanAudio)(id<GSLSignalingProtocal> signaling, BOOL banAudio);

/**
 失去和主播的连接
 
 @note 这里是被动失去，主播端主动断开连接
 */
@property (nonatomic, copy) void(^onDisconnectToAnchor)(id<GSLSignalingProtocal> signaling);


/////////////////////////////////////////////////////////////////////////////////
//
//                      （五）远端用户事件回调
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark- 远端用户事件回调

/**
 有用户被禁画/解禁
 
 @param banVideo YES：禁画 | NO：解禁
 @param userId 远端用户的用户 ID
 */
@property (nonatomic, copy) void(^onAudienceBanVideo)(id<GSLSignalingProtocal> signaling, BOOL banVideo, NSString *userId);

/**
 有用户被禁音/解禁
 
 @param mute YES：禁音 | NO：解禁
 @param userId 远端用户的用户 ID
 */
@property (nonatomic, copy) void(^onAudienceBanAudio)(id<GSLSignalingProtocal> signaling, BOOL mute, NSString *userId);

/////////////////////////////////////////////////////////////////////////////////
//
//                      （六）服务连接状态回调
//
/////////////////////////////////////////////////////////////////////////////////
#pragma mark- 服务连接状态回调

/**
 服务器连接状态改变
 
 @param connectStatus 服务器连接状态
 */
@property (nonatomic, copy) void(^onServerConnectStatusChange)(id<GSLSignalingProtocal> player, BOOL connectStatus);

@end

NS_ASSUME_NONNULL_END
