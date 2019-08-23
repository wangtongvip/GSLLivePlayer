# GSLSignalingCenter <信令SDK>
哥斯拉信令

当前版本：1.1.1

### 版本更新日志

> V1.1.1：
>
> 初版
>
> 能力如下：
>
> 1. 用户加入退出房间
> 
> 2. 收发消息
> 
> 3. 连接状态回调
> 
> 4. 错误回调
> 

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

1. 将```GSLSignalingCenterFramework.framework```导入项目
2. 导入头文件```#import <GSLSignalingCenterFramework/GSLSignalingCenterFramework.h>```

```
如果使用打包完的 Framework 有出现崩溃的情况或者找不到类别，可以考虑在项目 Other linker flags 中加入一些参数，下面介绍三个常用参数：

-ObjC：加了这个参数后，链接器就会把静态库中所有的 Objective-C 类和分类都加载到最后的可执行文件中。

-all_load：会让链接器把所有找到的目标文件都加载到可执行文件中，但是千万不要随便使用这个参数！假如你使用了不止一个静态库文件，然后又使用了这个参数，那么你很有可能会遇到 ld: duplicate symbol 错误，因为不同的库文件里面可能会有相同的目标文件，所以建议在遇到 -ObjC 失效的情况下使用 -force_load 参数。

-force_load：所做的事情跟 -all_load 其实是一样的，但是 -force_load 需要指定要进行全部加载的库文件的路径，这样的话，你就只是完全加载了一个库文件，不影响其余库文件的按需加载。
```

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

##### 信令系统的连接状态

>信令系统的连接状态，YES：连接 | NO：断开连接

```
@property(nonatomic, assign, readonly) BOOL connected;
```

##### 信令回调事件的代理列表

```
@property(nonatomic, copy, readonly) NSArray *delegateList;
```

##### 设代理的注册与注销
 
> @note 

> * 在不需要时，一定要调用```removeDelegate```方法及时释放代理。否者可能导致引用方无法释放的问题。

> @param delegate 需要监听信令事件的代理

```
- (void)registDelegate:(id<GSLSignalingCenterDelegate>)delegate;
- (void)removeDelegate:(id<GSLSignalingCenterDelegate>)delegate;
- (void)removeAllDelegate;
```

##### 连接信令系统

> @param appId 应用Id
> 
> @param roomId 信令房间Id
> 
> @param token 用户签名
> 
> @param userFlag 用户标识
> 
> @param userRole 用户的角色
> 
> @param groupFlag 组标识（目前设置为 @"all"）
> 
> @param error 连接时的错误信息

```
- (void)connectWithAppId:(NSString *)appId roomId:(NSString *)roomId token:(NSString *)token userFlag:(NSString *)userFlag userRole:(NSString *)userRole groupFlag:(NSString *)groupFlag error:(NSError **)error;
```

##### 重连

```
- (void)reconnect;
```

##### 断开连接

```
- (void)disConnect;
```

##### 发送目标消息

> @param messageType 消息类型 自定义的消息一般放在GSLSignalingMessageTypeCustom类型
> 
> @param subMessageType 消息子类型
> 
> @param userId 目标用户Id
> 
> @param userRole 用户角色
> 
> @param body 消息体

```
- (void)sendMessageToUserWithType:(GSLSignalingMessageType)messageType subType:(NSString *)subMessageType userId:(NSString *)userId userRole:(NSString *)userRole body:(NSDictionary *)body;
```

##### 发送群组消息

> @param messageType 消息类型 自定义的消息一般放在GSLSignalingMessageTypeCustom类型
> 
> @param subMessageType 消息子类型
> 
> @param groupId 目标组Id
> 
> @param body 消息体

 ```
- (void)sendMessageToGroupWithType:(GSLSignalingMessageType)messageType subType:(NSString *)subMessageType groupId:(NSString *)groupId body:(NSDictionary *)body;
 ```
 
 <br>
 <br>
 <br>
 
#### GSLSignalingCenterDelegate

##### 连接状态改变

> @param center 信令中心
> 
> @param success YES：已连接 | NO：未连接

```
- (void)signalingCenter:(GSLSignalingCenter *)center connectSuccess:(BOOL)success;
```

##### 错误回调
 
> @param center 信令中心
> 
> @param error 错误体

```
- (void)signalingCenter:(GSLSignalingCenter *)center onError:(NSError *)error;
```

##### 有用户进入房间

> @param center 信令中心
> 
> @param userFlag 用户标识
> 
> @param groupFlag 组号
> 
> @param userRole 用户角色
> 
> @param body 消息体

```
- (void)signalingCenter:(GSLSignalingCenter *)center onUserJoin:(NSString *)userFlag groupFlag:(NSString *)groupFlag userRole:(NSString *)userRole body:(NSDictionary *)body;
```

##### 有用户退出房间

> @param center 信令中心
> 
> @param userFlag 用户标识
> 
> @param groupFlag 组号
> 
> @param userRole 用户角色
> 
> @param body 消息体

```
- (void)signalingCenter:(GSLSignalingCenter *)center onUserLeave:(NSString *)userFlag groupFlag:(NSString *)groupFlag userRole:(NSString *)userRole body:(NSDictionary *)body;
```

##### 收到消息

> @param center 信令中心
> @param messageType 消息类型
> @param body 消息体

```
- (void)signalingCenter:(GSLSignalingCenter *)center didReceiveMessageWithType:(GSLSignalingMessageType)messageType messageBody:(NSDictionary *)body;
```

#### 异常码及说明

❌码

ERROR CODE          | DESCRIPTION      |
--------------------|------------------|
-10000 | 信令服务未能激活 |
-20000 | 信令服务返回异常信息 |
-30000 | 消息发送异常 |

⚠️码

WARNING CODE        | DESCRIPTION      |
--------------------|------------------|
 |  |
