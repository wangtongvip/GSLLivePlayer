# GSLLivePlayer <六路连麦SDK>

哥斯拉 六路连麦

当前版本：1.1.1

### 版本更新日志

> V1.1.1：
>
> 初版
>
> 能力如下：
>
> 1. 直播控制：初始化（设置）、加入/离开直播、启动/关闭本地摄像头预览、开启/关闭本地音视频推流、播放/关闭远端流
> 
> 2. 连麦控制：发起连麦申请（观众发起）、接受/拒绝连麦邀请（观众操作）、结束连麦
> 
> 3. 事件通知：远端流加入/断开通知、禁止/恢复音视频通知、收到连麦邀请通知、连接断开通知
> 
> 4. 自定义消息：通过获取信令对象实现收发自定义消息

### 接口迁移

无

### 已知问题

无

### 修复问题 

无

### 接入说明

#### 兼容性

系统：iOS 9.0+

设备：iPhone iPad

#### 集成方法

1. 将```GSLLivePlayerFramework.framework```导入项目
2. 添加依赖库```libc++.tbd```
3. 导入头文件```#import <GSLLivePlayerFramework/GSLLivePlayerFramework.h>```
4. 建议同时集成```GSLSignalingCenterFramework.framework```，使用```GSLSignalingManager```支撑直播的控制逻辑
5. 也可使用自己的信令服务，但是需要遵循```GSLSignalingProtocal```协议的能力

#### **API说明：**

___

#### SDK 基础函数

___

##### 当前SDK版本号

>返回的是字符串，如@"1.1.1"

```
+ (NSString *)version;
```

##### 调试时是否需要打印调试信息
 
> @param open YES：打印 | NO：不打印

```
+ (void)openDebugLogInfo:(BOOL)open;
```

##### 单例初始化方法

>创建 GSLLivePlayer 单例

```
+ (instancetype)sharedInstance;
```

##### 销毁 GSLLivePlayer 单例

```
+ (void)destroySharedIntance;
```

##### 设置回调接口 GSLLivePlayerDelegate
 
> @note 

> * 您也可以通过事件回调的block获取回调信息

```
@property (nonatomic, assign) id <GSLLivePlayerDelegate> delegate;
```

##### 信令管理器

>@note

>* 建议同时集成```GSLSignalingCenterFramework.framework```，使用```GSLSignalingManager```支撑直播的控制逻辑
>* 当然您也可使用自己的信令服务，但是需要遵循```GSLSignalingProtocal```协议的能力

```
@property (nonatomic, strong) id <GSLSignalingProtocal> signalingManager;
```

##### 配置播放器的参数

>@note

>* 此方法初始化成功后会以block的形式回调，您在block中处理代码逻辑时，**需要对您的对象做非空判断**，并且**注意防止循环引用**

>* 只有在配置参数并且回调成功后，才能进房，否则进房会失败
 
> @param configuration 初始化参数
> 
> @param success 初始化成功的回调
> 
> @param failure 初始化失败的回调

```
- (void)configurePlayerWithConfiguration:(GSLPlayerConfiguration *)configuration success:(void (^)(NSString *liveUserId))success failure:(void (^)(NSError *ERROR))failure;
```

##### 直播时的当前用户Id

```
@property (nonatomic, strong, readonly) NSString *userId;
```

<br>
<br>
<br>

___

#### SDK 基础属性

___

##### 辅助视图

>@note

>* 辅助视图目前是主播端的屏幕分享等辅助视图窗口

>* 用户可以根据需要布局辅助视图位置，视图默认填充完整的父视图。空缺处是黑色留白

```
@property (nonatomic, strong, readonly) GSLLiveView *assistView;
```

##### 主播的视图

 ```
@property (nonatomic, strong, readonly) GSLLiveView *anchorView;
 ```

##### 远端视频的集合

>@note 

>* 所有连麦观众的视图集合

>* 当前用户或远端用户连麦后，会加入此数组

>* 此数组的加入和移除，必须通过调用以下方法才会维护

>> \- (void)startLocalView:(BOOL)frontCamera view:(nonnull GSLLiveView *)view;

>> \- (void)stopLocalView;

>> \- (void)startRemoteView:(NSString *)userId view:(nonnull GSLLiveView *)view;

>> \- (void)stopRemoteView:(NSString *)userId;

```
@property (nonatomic, strong, readonly) NSMutableArray<GSLLiveView *> *remoteViews;
```

##### 通过userId找到remoteViews中对应的view
 
> @return 找到的视图，找不到返回nil

```
- (GSLLiveView *)getCacheRemoteViewWithUserId:(NSString *)userId;
```

##### 远端视频链接上后在 remoteViews 的排列顺序

>@note

>* 需要在进房之前设置

```
@property (nonatomic, assign) GSLLiveRemoteOrder remoteOrder;
```

##### 当前用户的连麦状态

```
@property (nonatomic, assign, readonly) GSLLiveLinkStatus linkStatus;
```

##### 当前用户的禁画状态

>@note 

>* 目前禁音禁画暴露给业务方处理，这个状业务方可以自己维护，SDK维护的是逻辑上的状态，真正的表现出的状态是依赖于业务方是否调用了静画方法

```
@property (nonatomic, assign, readonly) GSLLiveBanVideoStatus banVideoStatus;
```

##### 当前用户的禁音状态

>@note 

>* 目前禁音禁画暴露给业务方处理，这个状业务方可以自己维护，SDK维护的是逻辑上的状态，真正的表现出的状态是依赖于业务方是否调用了静音方法

```
@property (nonatomic, assign, readonly) GSLLiveBanAudioStatus banAudioStatus;
```

##### 当前服务器连接状态

```
@property (nonatomic, assign, readonly) GSLLiveConnectStatus connectStatus;
```

<br>
<br>
<br>

___

#### 房间相关接口函数

___

##### 进入房间
 
>@note 

>* 需要在配置播放器成功后才可调用此方法。配置播放器：

>> \- (void)configurePlayerWithConfiguration: success: failure: ;

```
- (void)enterRoom;
```

##### 离开房间

```
- (void)exitRoom;
```

<br>
<br>
<br>

___

#### 视频相关接口函数

___

##### 打开本地视频预览

>@note 

>* 打开本地预览后，对方无法看到你的画面，只有调用startLocalView:view:方法后才真正推流，其他人才能看到你的画面

>* view不可以为nil

>@param frontCamera YES：前置摄像头；NO：后置摄像头

>@param view 承载视频画面的控件

```
- (void)startLocalPreview:(BOOL)frontCamera view:(GSLLiveView *)view;
```

##### 停止本地视频预览

```
- (void)stopLocalPreview;
```

##### 展示本地视频并将流推向远端

>@note

>* 调用此方法后，remoteViews这个属性中就会维护这个画面

>@param frontCamera YES：前置摄像头；NO：后置摄像头

>@param view 承载视频画面的控件

```
- (void)startLocalView:(BOOL)frontCamera view:(GSLLiveView *)view;
```

##### 停止本地视频并结束推送画面

>@note

>* 调用此方法后，remoteViews这个属性中就会移除这个视频画面

```
- (void)stopLocalView;
```

##### 开始显示远端视频画面

>@note 

>* 在收到 SDK 的 onAudienceAvailable 回调时，调用这个接口，就可以显示远端视频的画面了。

>* 调用此方法后，remoteViews这个属性中就会维护这个视频画面。
 
>@param userId 对方的用户标识

>@param view 承载视频画面的控件

```
- (void)startRemoteView:(NSString *)userId view:(GSLLiveView *)view;
```

##### 停止显示远端视频画面

>@note

>* 调用此方法后，remoteViews这个属性中就会移除这个视频画面

>@param userId 对方的用户标识

```
- (void)stopRemoteView:(NSString *)userId;
```

##### 开始显示远端用户的辅助画面

>@note

>* 在收到 SDK 的 onAssistAvailable 回调时，调用这个接口，就可以显示远端视频的画面了

>* 调用此方法后，assistView这个属性中已经存在远端视频画面。
 
>@param userId 对方的用户标识

>@param view 渲染控件

```
- (void)startRemoteSubStreamView:(NSString *)userId view:(GSLLiveView *)view;
```

##### 停止显示远端用户的辅助画面

>@note

>* 调用此方法后，assistView这个属性就会移除视频画面，此属性置为nil

>@param userId 对方的用户标识

```
- (void)stopRemoteSubStreamView:(NSString *)userId;
```

##### 屏蔽本地视频采集

>@note

>* 依然推送黑屏画面

>@param mute 是否屏蔽本地画面采集 YES：屏蔽 | NO：打开

```
- (void)muteLocalVideo:(BOOL)mute;;
```

##### 静音掉某一个远端用户的视频
 
>@param userId userId 对方的用户 ID

>@param mute YES：静画；NO：非静画

```
- (void)muteRemoteVideo:(NSString *)userId mute:(BOOL)mute;
```

##### 静音掉所有远端用户的视频

>@param mute YES：静画；NO：非静画

```
- (void)muteAllRemoteVideo:(BOOL)mute;
```

##### 设置本地图像的填充模式

>@param mode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边）

```
- (void)setLocalViewFillMode:(GSLLiveVideoFillMode)mode;
```

##### 设置远端图像的填充模式

>@param userId 用户 ID

>@param mode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边）

```
- (void)setRemoteViewFillMode:(NSString*)userId mode:(GSLLiveVideoFillMode)mode;
```

##### 设置辅助画面的显示模式

>@param userId 用户的 ID

>@param mode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边）

```
- (void)setRemoteSubStreamViewFillMode:(NSString *)userId mode:(GSLLiveVideoFillMode)mode;
```

##### 设置上行视频画面质量和屏幕方向

>@note

>* 此方法需要在进房成功后（onEnterRoom）设置才会生效

>* 建议在屏幕旋转时判断需要推送的是横屏画面或竖屏画面，然后设置相应的横竖屏画面质量方式。判断controller的横竖屏可以使用以下方法：

>> \- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

>@param param 质量参数

```
- (void)setVideoQosParam:(GSLLiveVideoQosParam)param;
```

##### 设置网络流控策略

>@param param 网络流控策略，详情请参考 GSLRTCCloudDef.h 中的 GSLRTCVideoQosPreference 定义

```
- (void)setNetworkQosParam:(GSLLiveVideoQosPreference *)param;
```

<br>
<br>
<br>

___

#### 音频相关接口函数

___

##### 开启本地音频的采集和上行

>@note 

>* 该函数会检查麦克风的使用权限，如果当前 App 没有麦克风权限，SDK 会向用户申请开启。

>* 该函数会启动麦克风采集，并将音频数据传输给房间里的其他用户。
 SDK 并不会默认开启本地的音频上行，也就说，如果您不调用这个函数，房间里的其他用户就听不到您的声音。

```
- (void)startLocalAudio;
```

##### 关闭本地音频的采集和上行

```
- (void)stopLocalAudio;
```

##### 静音本地的音频

>@note 

>* 与 stopLocalAudio 不同之处在于，muteLocalAudio 并不会停止发送音视频数据，而是会继续发送码率极低的静音包

>@param mute YES：屏蔽；NO：开启

```
- (void)muteLocalAudio:(BOOL)mute;
```

##### 静音掉某一个用户的声音

>@param userId 对方的用户 ID

>@param mute  YES：静音；NO：非静音

```
- (void)muteRemoteAudio:(NSString *)userId mute:(BOOL)mute;
```

##### 静音掉所有远端用户的声音

>@param mute YES：静音；NO：非静音

```
- (void)muteAllRemoteAudio:(BOOL)mute;
```

<br>
<br>
<br>

___

#### 硬件相关接口函数

___

##### 切换摄像头

>@note

>* 切换推流时的镜头


```
- (void)switchCamera;
```

##### 切换预览摄像头

>@note

>* 切换视频预览时的镜头

```
- (void)switchPreviewCamera;
```

<br>
<br>
<br>

___

#### 用户行为相关接口函数

___

##### 申请连麦

```
- (void)applyConnectToAnchor;
```

##### 同意连麦

```
- (void)agreeConnectToAnchor;
```

##### 拒绝连麦

```
- (void)refuseConnectToAnchor;
```

##### 用户断开连麦

```
- (void)disConnectToAnchor;
```

<br>
<br>
<br>

___

#### 事件回调

##### 以下事件回调与`GSLLivePlayerDelegate`的能力吻合，您可以选择通过`block`的形式监听回调(需要考虑循环引用的问题)，或通过`delegate`的形式监听回调

___

<br>
<br>
<br>

___

#### 系统事件回调

___

##### 错误回调：SDK 不可恢复的错误，一定要监听，并分情况给用户适当的界面提示。

>@param errorCode 错误码

>@param extErrorCode 扩展错误码

>@param errorMessage 错误信息

>@param extInfo 扩展信息字段，个别错误码可能会带额外的信息帮助定位问题

```
@property (nonatomic, copy) void(^onError)(id<GSLLivePlayerProtocal> player, GSLLiveErrorCode errorCode, int extErrorCode, NSString *_Nullable errorMessage, NSDictionary *_Nullable extInfo);
```

##### 警告回调：用于告知您一些非严重性问题，比如出现了卡顿或者可恢复的解码失败。

>@param warningCode 警告码

>@param extWarningCode 扩展警告码

>@param warningMessage 警告信息

>@param extInfo 扩展信息字段，个别警告码可能会带额外的信息帮助定位问题

```
@property (nonatomic, copy) void(^onWarning)(id<GSLLivePlayerProtocal> player, GSLLiveWarningCode warningCode, int extWarningCode, NSString *_Nullable warningMessage, NSDictionary *_Nullable extInfo);
```
<br>
<br>
<br>

___

#### pragma mark- 当前用户事件回调

___

##### 加入房间

```
@property (nonatomic, copy) void(^onEnterRoom)(GSLLivePlayer *player);
```

##### 离开房间

```
@property (nonatomic, copy) void(^onExitRoom)(GSLLivePlayer *player);
```

##### 收到连麦邀请

```
@property (nonatomic, copy) void(^onInviteConnectToAnchor)(GSLLivePlayer *player);
```

##### 连麦申请被同意
 
> @param banVideo 是否被禁画

> @param banAudio 是否被禁音

```
@property (nonatomic, copy) void(^onAgreeConnectToAnchor)(GSLLivePlayer *player, BOOL banVideo, BOOL banAudio);
```

##### 连麦申请被拒绝

```
@property (nonatomic, copy) void(^onRefuseConnectToAnchor)(GSLLivePlayer *player);
```

##### 被禁画/解禁
 
> @param banVideo YES：禁音 | NO：解禁

```
@property (nonatomic, copy) void(^onBanVideo)(GSLLivePlayer *player, BOOL banVideo);
```

##### 被禁音/解禁
 
> @param banAudio YES：禁音 | NO：解禁

```
@property (nonatomic, copy) void(^onBanAudio)(GSLLivePlayer *player, BOOL banAudio);
```

##### 失去和主播的连接

>@note 

>* 这里是被动失去，主播端主动断开连接

```
@property (nonatomic, copy) void(^onDisconnectToAnchor)(GSLLivePlayer *player);
```

<br>
<br>
<br>

___

#### pragma mark- 远端用户事件回调

___

##### 辅助画面可展示或消失

>@param available YES：可展示 | NO：消失

>@param userId 辅助画面用户编号，同 用户的ID

```
@property (nonatomic, copy) void(^onAssistAvailable)(GSLLivePlayer *player, BOOL available, NSString *userId);
```

##### 主播可展示或消失

>@param available YES：可展示 | NO：消失

>@param userId 主播的用户 ID

```
@property (nonatomic, copy) void(^onAnchorAvailable)(GSLLivePlayer *player, BOOL available, NSString *userId);
```

##### 有远端用户可展示或消失

>@param available YES：可展示 | NO：消失

>@param userId 远端用户的用户 ID

>@param banVideo 是否被禁画

>@param banAudio 是否被禁音

```
@property (nonatomic, copy) void(^onAudienceAvailable)(GSLLivePlayer *player, BOOL available, NSString *userId, BOOL banVideo, BOOL banAudio);
```

##### 有用户被禁画/解禁
 
> @param banVideo YES：禁画 | NO：解禁

> @param userId 远端用户的用户 ID

```
@property (nonatomic, copy) void(^onAudienceBanVideo)(GSLLivePlayer *player, BOOL banVideo, NSString *userId);
```

##### 有用户被禁音/解禁
 
> @param banAudio YES：禁音 | NO：解禁

> @param userId 远端用户的用户 ID

```
@property (nonatomic, copy) void(^onAudienceBanAudio)(GSLLivePlayer *player, BOOL banAudio, NSString *userId);
```

<br>
<br>
<br>

___

#### 质量参数回调

___

##### 网络质量：该回调每2秒触发一次，统计当前网络的上行和下行质量

>@note 

>* userId == nil 代表自己当前的视频质量

>@param localQuality 上行网络质量

>@param remoteQuality 下行网络质量

```
@property (nonatomic, copy) void(^onNetworkQuality)(GSLLivePlayer *player, GSLLiveQualityInfo *_Nullable localQuality, NSArray<GSLLiveQualityInfo *> *_Nullable remoteQuality);
```

##### 用于提示音量大小的回调,包括每个 userId 的音量和远端总音量

>@note 

>* 该回调每300ms秒触发一次，统计当前网络的上行和下行质量
 
>@param userVolumes userVolumes 所有正在说话的房间成员的音量（取值范围0 - 100）。即 userVolumes 内仅包含音量不为0（正在说话）的用户音量信息。其中 userId 为 null  表示 local 的音量，也就是自己的音量。

>@param totalVolume totalVolume 所有远端成员的总音量, 取值范围0 - 100

```
@property (nonatomic, copy) void(^onUserVoiceVolume)(GSLLivePlayer *player, NSArray<GSLLiveVolumeInfo *> *_Nullable userVolumes, NSInteger totalVolume);
```

<br>
<br>
<br>

___

#### pragma mark- 服务器状态回调

___

##### 服务器连接状态改变

>@param connectStatus 服务器连接状态

```
@property (nonatomic, copy) void(^onServerConnectStatusChange)(GSLLivePlayer *player, GSLLiveConnectStatus connectStatus);
```

<br>
<br>
<br>

#### 异常码及说明

❌码

ERROR CODE          | DESCRIPTION      |
--------------------|------------------|
0 | 无错误 |
-1101 | 摄像头设备未授权，通常在移动设备出现，可能是权限被用户拒绝了 |
-1102 | 麦克风设备未授权，通常在移动设备出现，可能是权限被用户拒绝了 |
-1201 | 音视频编解码出现问题 |
-1301 | 服务器拒绝访问   |
-1401 | 进房失败（未知原因） |
-1402 | 进房参数为空 |
-1403 | 进房参数 sdkAppId 错误 |
-1404 | 进房参数 roomId 错误 |
-1405 | 进房参数 userID 不正确 |
-1406 | 进房参数 userSig 不正确 |
-2101 | 当前用户不在房间，无法申请连麦 |
-2102 | 当前主播不在线，无法申请连麦 |
-2103 | 当前用户不在房间内，无法同意连麦邀请 |
-9000 | 其他 |
12000002 | 缺少直播信息 |

⚠️码

WARNING CODE        | DESCRIPTION      |
--------------------|------------------|
0 | 无警告 |
1101 | 网络状况不佳：上行带宽太小，上传数据受阻 |
1102 | 当前视频播放出现卡顿（用户直观感受） |
1103 | 直播，超过30s 没有数据发送，主动断开连接 |
1104 | 网络断开连接 |
1105 | 网络断连，已启动自动重连 |
9000 | 其他警告类型 |
