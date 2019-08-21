//
//  GSLSignalingCenter.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

//  version 1.1.1

/**
 GSL信令中心
 */

#import "GSLSignalingCenterDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSLSignalingCenter : NSObject

/// 信令系统的连接状态
@property(nonatomic, assign, readonly) BOOL connected;

/// 信令回调事件的代理列表
@property(nonatomic, copy, readonly) NSArray *delegateList;

/// 获取当前SDK版本号
+ (NSString *)version;

/// 调试时是否需要打印调试信息
/// @param open YES：打印 | NO：不打印
+ (void)openDebugLogInfo:(BOOL)open;

/// 代理的注册与注销
/// @param delegate 需要监听信令事件的代理
/// @note 在不需要时，一定要调用removeDelegate方法及时释放代理。否者可能导致引用方无法释放的问题。
- (void)registDelegate:(id<GSLSignalingCenterDelegate>)delegate;
- (void)removeDelegate:(id<GSLSignalingCenterDelegate>)delegate;
- (void)removeAllDelegate;


/// 连接信令系统
/// @param appId 应用Id
/// @param roomId 信令房间Id
/// @param token 用户签名
/// @param userFlag 用户标识
/// @param userRole 用户的角色
/// @param groupFlag 组标识（目前设置为 @"all"）
/// @param error 连接时的错误信息
- (void)connectWithAppId:(NSString *)appId
                  roomId:(NSString *)roomId
                   token:(NSString *)token
                userFlag:(NSString *)userFlag
                userRole:(NSString *)userRole
               groupFlag:(NSString *)groupFlag
                   error:(NSError **)error;

/// 重连
- (void)reconnect;

/// 断开连接
- (void)disConnect;

/// 发送目标消息
/// @param messageType 消息类型 自定义的消息一般放在GSLSignalingMessageTypeCustom类型
/// @param subMessageType 消息子类型
/// @param userId 目标用户Id
/// @param userRole 用户角色
/// @param body 消息体
- (void)sendMessageToUserWithType:(GSLSignalingMessageType)messageType
                          subType:(NSString *)subMessageType
                           userId:(NSString *)userId
                         userRole:(NSString *)userRole
                             body:(NSDictionary *)body;

/// 发送群组消息
/// @param messageType 消息类型 自定义的消息一般放在GSLSignalingMessageTypeCustom类型
/// @param subMessageType 消息子类型
/// @param groupId 目标组Id
/// @param body 消息体
- (void)sendMessageToGroupWithType:(GSLSignalingMessageType)messageType
                           subType:(NSString *)subMessageType
                           groupId:(NSString *)groupId
                              body:(NSDictionary *)body;

@end


NS_ASSUME_NONNULL_END
