//
//  GSLSignalingDelegate.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 GSL信令中心事件回调代理
 */

#import <Foundation/Foundation.h>
#import "GSLSignalingCenterDef.h"

@class GSLSignalingCenter;

NS_ASSUME_NONNULL_BEGIN

@protocol GSLSignalingCenterDelegate <NSObject>

@optional

/// 连接状态改变
/// @param center 信令中心
/// @param success YES：已连接 | NO：未连接
- (void)signalingCenter:(GSLSignalingCenter *)center connectSuccess:(BOOL)success;

/// 错误
/// @param center 信令中心
/// @param error 错误体
- (void)signalingCenter:(GSLSignalingCenter *)center onError:(NSError *)error;

/// 有用户进入房间
/// @param center 信令中心
/// @param userFlag 用户标识
/// @param groupFlag 组号
/// @param userRole 用户角色
/// @param body 消息体
- (void)signalingCenter:(GSLSignalingCenter *)center
             onUserJoin:(NSString *)userFlag
              groupFlag:(NSString *)groupFlag
               userRole:(NSString *)userRole
                   body:(NSDictionary *)body;

/// 有用户退出房间
/// @param center 信令中心
/// @param userFlag 用户标识
/// @param groupFlag 组号
/// @param userRole 用户角色
/// @param body 消息体
- (void)signalingCenter:(GSLSignalingCenter *)center
            onUserLeave:(NSString *)userFlag
              groupFlag:(NSString *)groupFlag
               userRole:(NSString *)userRole
                   body:(NSDictionary *)body;

/// 收到消息
/// @param center 信令中心
/// @param messageType 消息类型
/// @param body 消息体
- (void)signalingCenter:(GSLSignalingCenter *)center didReceiveMessageWithType:(GSLSignalingMessageType)messageType messageBody:(NSDictionary *)body;

@end

NS_ASSUME_NONNULL_END
