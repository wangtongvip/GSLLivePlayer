//
//  GSLSignalingCenterDef.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 GSL信令 类型及枚举定义
 */

/// 信令类型
typedef NS_ENUM(NSInteger, GSLSignalingMessageType) {
    GSLSignalingMessageTypeCommon   = 1,  ///< 公共
    GSLSignalingMessageTypeCustom   = 2,  ///< 定制
    GSLSignalingMessageTypeCommand  = 3,  ///< 命令
    GSLSignalingMessageTypeSystem   = 4,  ///< 系统
    GSLSignalingMessageTypeLive     = 5,  ///< 直播控制
    GSLSignalingMessageTypeExtra    = 7,  ///< 扩展
};

/// 消息类型
typedef NS_ENUM(NSInteger, GSLSignalingMessageRange) {
    GSLSignalingMessageRangeUser    = 0,  ///< 个人消息
    GSLSignalingMessageRangeGroup   = 1,  ///< 群组消息
};

/// 错误类型
typedef NS_ENUM(NSInteger, GSLSignalingError) {
    GSLSignalingError_signaling_server_unActive  = -10000,  ///< 信令服务未能激活
    GSLSignalingError_signaling_server_faild     = -20000,  ///< 信令服务返回异常信息
    GSLSignalingError_send_message_faild         = -30000,  ///< 消息发送异常
};




