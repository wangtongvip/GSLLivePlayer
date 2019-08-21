//
//  GSLLivePlayerDef.h
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/2.
//  Copyright © 2019 wangtong. All rights reserved.
//

/**
 GSLTRTC类型及枚举定义
 */

#import "GSLLPObject.h"

/**
 视频画面填充模式
 
 如果画面的显示分辨率不等于画面的原始分辨率，就需要您设置画面的填充模式:
 - GSLLiveVideoFillMode_Fill: 图像铺满屏幕，超出显示视窗的视频部分将被截掉，所以画面显示可能不完整
 - GSLLiveVideoFillMode_Fit: 图像长边填满屏幕，短边区域会被填充黑色，但画面的内容肯定是完整的
 */
typedef NS_ENUM(NSInteger, GSLLiveVideoFillMode) {
    GSLLiveVideoFillMode_Fill   = 0,  ///< 图像铺满屏幕，超出显示视窗的视频部分将被截掉
    GSLLiveVideoFillMode_Fit    = 1,  ///< 图像长边填满屏幕，短边区域会被填充黑色
};

/**
 流控策略
 
 当 GSLLive SDK 在遇到弱网络环境时，您是希望“保清晰”还是“保流畅”：
 - GSLLiveVideoQosPreference_Smooth: 弱网下保流畅，在遭遇弱网环境时首先确保声音的流畅和优先发送，画面会变得模糊且会有较多马赛克，但可以保持流畅不卡顿
 - GSLLiveVideoQosPreference_Clear: 弱网下保清晰，在遭遇弱网环境时，画面会尽可能保持清晰，但可能会更容易出现卡顿
 */
typedef NS_ENUM(NSInteger, GSLLiveVideoQosPreference) {
    GSLLiveVideoQosPreference_Smooth = 1,      ///< 弱网下保流畅
    GSLLiveVideoQosPreference_Clear  = 2,      ///< 弱网下保清晰
};

/**
 视频画面旋转方向
 
 GSLLive SDK 提供了对本地和远程画面的旋转角度设置 API，如下的旋转角度都是指顺时针方向的
 - GSLLiveVideoRotation_0: 不旋转
 - GSLLiveVideoRotation_90: 顺时针旋转90度
 - GSLLiveVideoRotation_180: 顺时针旋转180度
 - GSLLiveVideoRotation_270: 顺时针旋转270度
 */
typedef NS_ENUM(NSInteger, GSLLiveVideoRotation) {
    GSLLiveVideoRotation_0      = 0,  ///< 不旋转
    GSLLiveVideoRotation_90     = 1,  ///< 顺时针旋转90度
    GSLLiveVideoRotation_180    = 2,  ///< 顺时针旋转180度
    GSLLiveVideoRotation_270    = 3,  ///< 顺时针旋转270度
};

/**
 画质级别
 
 - GSLLiveQuality_Unknown: 未定义
 - GSLLiveQuality_Excellent: 最好
 - GSLLiveQuality_Good: 好
 - GSLLiveQuality_Poor: 一般
 - GSLLiveQuality_Bad: 差
 - GSLLiveQuality_Vbad: 很差
 - GSLLiveQuality_Down: 不可用
 */
typedef NS_ENUM(NSInteger, GSLLiveQuality) {
    GSLLiveQuality_Unknown     = 0,     ///< 未定义
    GSLLiveQuality_Excellent   = 1,     ///< 最好
    GSLLiveQuality_Good        = 2,     ///< 好
    GSLLiveQuality_Poor        = 3,     ///< 一般
    GSLLiveQuality_Bad         = 4,     ///< 差
    GSLLiveQuality_Vbad        = 5,     ///< 很差
    GSLLiveQuality_Down        = 6,     ///< 不可用
};

/**
 远端视频加入后在 remoteViews 中的排序
 
 - GSLLiveRemoteOrder_Asc: 后加入的排在后面
 - GSLLiveRemoteOrder_Desc: 后加入的排在前面
 */
typedef NS_ENUM(NSInteger, GSLLiveRemoteOrder) {
    GSLLiveRemoteOrder_Asc      = 0,  ///< 后加入的排在后面
    GSLLiveRemoteOrder_Desc     = 1,  ///< 后加入的排在前面
};

/**
 连麦状态
 
 - GSLLiveLinkStatus_false: 未连麦
 - GSLLiveLinkStatus_true: 已连麦
 */
typedef NS_ENUM(NSInteger, GSLLiveLinkStatus) {
    GSLLiveLinkStatus_false    = 0,  ///< 未连麦
    GSLLiveLinkStatus_true     = 1,  ///< 已连麦
};

/**
 是否被禁画
 
 - GSLLiveBanVideoStatus_false: 未被禁画
 - GSLLiveBanVideoStatus_true: 已被禁画
 */
typedef NS_ENUM(NSInteger, GSLLiveBanVideoStatus) {
    GSLLiveBanVideoStatus_false    = 0,  ///< 未被禁画
    GSLLiveBanVideoStatus_true     = 1,  ///< 已被禁画
};

/**
 是否被禁音
 
 - GSLLiveBanAudioStatus_false: 未被禁音
 - GSLLiveBanAudioStatus_true: 已被禁音
 */
typedef NS_ENUM(NSInteger, GSLLiveBanAudioStatus) {
    GSLLiveBanAudioStatus_false    = 0,  ///< 未被禁音
    GSLLiveBanAudioStatus_true     = 1,  ///< 已被禁音
};

/**
 与当前服务器的连接状态
 
 -GSLLiveConnectStatus_unKnown: 未知
 - GSLLiveConnectStatus_connected: 已连接
 - GSLLiveConnectStatus_disConnect: 断开连接
 - GSLLiveConnectStatus_connecting: 正在连接
 */
typedef NS_ENUM(NSInteger, GSLLiveConnectStatus) {
    GSLLiveConnectStatus_unKnown      = 0,  ///< 未知
    GSLLiveConnectStatus_disConnect   = 1,  ///< 断开连接
    GSLLiveConnectStatus_connected    = 2,  ///< 已连接
    GSLLiveConnectStatus_connecting   = 3,  ///< 正在连接
};

/**
 视频分辨率
 
 @note 此处仅定义了横屏分辨率，如果要使用360 × 640这样的竖屏分辨率，需要同时指定 GSLLiveVideoResolutionMode 为 Portrait。
 */
typedef NS_ENUM(NSInteger, GSLLiveVideoResolution) {
    // 宽高比1:1
    GSLLiveVideoResolution_160_160     = 1,    ///< [C] 建议码率100kbps
    GSLLiveVideoResolution_270_270     = 3,    ///< [C] 建议码率200kbps
    GSLLiveVideoResolution_480_480     = 5,    ///< [C] 建议码率350kbps
    
    // 宽高比4:3
    GSLLiveVideoResolution_240_180     = 31,   ///< [C] 建议码率150kbps
    GSLLiveVideoResolution_320_240     = 33,   ///< [C] 建议码率250kbps
    GSLLiveVideoResolution_480_360     = 35,   ///< [C] 建议码率400kbps
    GSLLiveVideoResolution_640_480     = 37,   ///< [C] 建议码率600kbps
    GSLLiveVideoResolution_960_720     = 39,   ///< [C] 建议码率1000kbps
    
    // 宽高比16:9
    GSLLiveVideoResolution_320_180     = 51,  ///< [C] 建议码率250kbps
    GSLLiveVideoResolution_480_270     = 53,  ///< [C] 建议码率350kbps
    GSLLiveVideoResolution_640_360     = 55,  ///< [C] 建议码率550kbps
    GSLLiveVideoResolution_960_540     = 57,  ///< [C] 建议码率850kbps
    GSLLiveVideoResolution_1280_720    = 59,  ///< [C] 建议码率1200kbps
    GSLLiveVideoResolution_1920_1080   = 61,  ///< [S] 建议码率1600kbps
};

/**
 视频宽高比模式

 @note 分辨率：GSLLiveVideoResolution_640_360 + GSLLiveVideoResolutionMode_landscape = 640 × 360
 */
typedef NS_ENUM(NSInteger, GSLLiveVideoResolutionMode) {
    GSLLiveVideoResolutionMode_landscape = 0,  ///< 横屏分辨率
    GSLLiveVideoResolutionMode_portrait  = 1,  ///< 竖屏分辨率
};


#pragma mark- code

/**
 GSLLivePlayer错误码
 */
typedef NS_ENUM(NSInteger, GSLLiveErrorCode) {
    GSLLiveErrorCode_null                         = 0,        ///< 无错误
    GSLLiveErrorCode_camera_not_authorized        = -1101,    ///< 摄像头设备未授权，通常在移动设备出现，可能是权限被用户拒绝了
    GSLLiveErrorCode_mic_not_authorized           = -1102,    ///< 麦克风设备未授权，通常在移动设备出现，可能是权限被用户拒绝了
    GSLLiveErrorCode_code_fail                    = -1201,    ///< 音视频编解码出现问题
    GSLLiveErrorCode_server_refuse                = -1301,    ///< 服务器拒绝访问
    GSLLiveErrorCode_enter_room_fail              = -1401,    ///< 进房失败（未知原因）
    GSLLiveErrorCode_enter_room_param_null        = -1402,    ///< 进房参数为空
    GSLLiveErrorCode_SDKAppId_invalid             = -1403,    ///< 进房参数 sdkAppId 错误
    GSLLiveErrorCode_roomId_invalid               = -1404,    ///< 进房参数 roomId 错误
    GSLLiveErrorCode_userId_invalid               = -1405,    ///< 进房参数 userID 不正确
    GSLLiveErrorCode_userSign_invalid             = -1406,    ///< 进房参数 userSig 不正确
    GSLLiveErrorCode_cant_applay_user_out_room    = -2101,    ///< 当前用户不在房间，无法申请连麦
    GSLLiveErrorCode_cant_applay_anchor_out_line  = -2102,    ///< 当前主播不在线，无法申请连麦
    GSLLiveErrorCode_cant_agree_user_out_room     = -2103,    ///< 当前用户不在房间内，无法同意连麦邀请
    GSLLiveErrorCode_other                        = -9000,    ///< 其他
};

/**
 GSLLivePlayer警告码
 */
typedef NS_ENUM(NSInteger, GSLLiveWarningCode) {
    GSLLiveWarningCode_null                         = 0,        ///< 无警告
    GSLLiveWarningCode_net_busy                     = 1101,     ///< 网络状况不佳：上行带宽太小，上传数据受阻
    GSLLiveWarningCode_stuck                        = 1102,     ///< 当前视频播放出现卡顿（用户直观感受）
    GSLLiveWarningCode_no_data                      = 1103,     ///< 直播，超过30s 没有数据发送，主动断开连接
    GSLLiveWarningCode_room_disconnect              = 1104,     ///< 网络断开连接
    GSLLiveWarningCode_room_reconnect               = 1105,     ///< 网络断连，已启动自动重连
    GSLLiveWarningCode_other                        = 9000,     ///< 其他警告类型
};


NS_ASSUME_NONNULL_BEGIN

#pragma mark- GSLLiveQualityInfo

/**
 上行画面质量
 
 @note 表示视频质量的好坏，通过这个数值，您可以在 UI 界面上用图标表征 userId 的通话线路质量
 */
@interface GSLLiveVideoQosParam : GSLLPObject
/// 分辨率
@property (nonatomic, assign) GSLLiveVideoResolution resolution;
/// 宽高比模式
@property (nonatomic, assign) GSLLiveVideoResolutionMode resolutionMode;
///【字段含义】视频采集帧率
///【推荐取值】15fps 或 20fps，10fps 以下会有轻微卡顿感，5fps 以下卡顿感明显，20fps 以上的帧率则过于浪费（电影的帧率也只有 24fps）。
///【特别说明】很多 Android 手机的前置摄像头并不支持15fps以上的采集帧率，部分过于突出美颜功能的 Android 手机前置摄像头的采集帧率可能低于10fps。
@property (nonatomic, assign) int videoFps;
///【字段含义】视频上行码率
///【推荐取值】推荐设置请参考本文件前半部分 GSLLiveVideoResolution 定义处的注释说明
///【特别说明】码率太低会导致视频中有很多的马赛克
@property (nonatomic, assign) int videoBitrate;
@end

#pragma mark- GSLLiveQualityInfo

/**
 视频质量
 
 @note 表示视频质量的好坏，通过这个数值，您可以在 UI 界面上用图标表征 userId 的通话线路质量
 */
@interface GSLLiveQualityInfo : GSLLPObject
/// 用户 ID
@property (nonatomic, copy, nullable) NSString* userId;
/// 视频质量
@property (nonatomic, assign) GSLLiveQuality quality;
@end

#pragma mark- GSLLiveVolumeInfo

/**
 音量大小
 
 @note 表示语音音量的评估大小，通过这个数值，您可以在 UI 界面上用图标表征 userId 是否有在说话
 */
@interface GSLLiveVolumeInfo : GSLLPObject
/// 说话者的 userId, nil 为自己
@property (strong, nonatomic, nullable) NSString *userId;
/// 说话者的音量, 取值范围0 - 100
@property (assign, nonatomic) NSUInteger volume;
@end

NS_ASSUME_NONNULL_END
