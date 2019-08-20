//
//  LiveRoomViewController.m
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/16.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import "LiveRoomViewController.h"
#import <GSLSignalingCenterFramework/GSLSignalingCenterFramework.h>
#import <GSLLivePlayerFramework/GSLLivePlayerFramework.h>
#import "PreviewView.h"
#import "LiveControlView.h"
#import "SettingManager.h"
//#import <AVFoundation/AVFoundation.h>

static float assistView_rate_H = 0.7f;
static float assistView_rate_V = 0.8f;

static float test_videoBitrate = 150;
static float test_videoFps = 15;

@interface LiveRoomViewController () <GSLSignalingCenterDelegate> {
    GSLSignalingManager *_signalingManager;
    
    GSLLivePlayer *_livePlayer;
    NSString *_liveUserId;
    
    UIView *_assistView;
    UIView *_anchorView;
    UIScrollView *_remoteViewScrollView;
    
    UILabel *_anchorLabel;
    UILabel *_assistLabel;
    UILabel *_audienceLabel;
    
    PreviewView *_previewView;
}

@end

@implementation LiveRoomViewController

- (void)dealloc {
    [_signalingManager destroySignaling];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_livePlayer exitRoom];
    [_signalingManager.signalingCenter removeDelegate:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    /* TODO 测试后台播放策略
     AVAudioSession *session = [AVAudioSession sharedInstance];
     [session setCategory:AVAudioSessionCategoryPlayback error:nil];
     [session setActive:YES error:nil];
     */
    
    [self initLivePlayer];
    [self loadUI];
}

- (void)initLivePlayer {
    _livePlayer = [GSLLivePlayer sharedInstance];
    
    NSError *error;
    _signalingManager = [[GSLSignalingManager alloc] initWithAppId:[[SettingManager shareManager] livePlayer_appId] roomId:[[SettingManager shareManager] livePlayer_roomId] userId:[[SettingManager shareManager] livePlayer_userId] token:[[SettingManager shareManager] livePlayer_token] error:&error];
    if (error) {
        [self showMessage:[NSString stringWithFormat:@"信令初始化出错 %@", error.description]];
    } else {
        [_signalingManager.signalingCenter registDelegate:self];
        _livePlayer.signalingManager = _signalingManager;
    }
    
    GSLPlayerConfiguration *configuration = [[GSLPlayerConfiguration alloc] init];
    configuration.appId = [[SettingManager shareManager] livePlayer_appId];
    configuration.liveId = [[SettingManager shareManager] livePlayer_liveId];
    configuration.roomId = [[SettingManager shareManager] livePlayer_roomId];
    configuration.token = [[SettingManager shareManager] livePlayer_token];
    
    __weak typeof(self)weakSelf = self;
    [_livePlayer configurePlayerWithConfiguration:configuration success:^(NSString * _Nonnull liveUserId) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        strongSelf->_liveUserId = liveUserId;
        [strongSelf->_livePlayer enterRoom];
    } failure:^(NSError * _Nonnull ERROR) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf showMessage:[NSString stringWithFormat:@"%@",ERROR.description]];
    }];
    
    _livePlayer.onEnterRoom = ^(GSLLivePlayer * _Nonnull player) {
    };
    
    _livePlayer.onExitRoom = ^(GSLLivePlayer * _Nonnull player) {
        // 退出房间后销毁播放单例
        [GSLLivePlayer destroySharedIntance];
    };
    
    _livePlayer.onError = ^(GSLLivePlayer *player, GSLLiveErrorCode errorCode, NSInteger extErrorCode, NSString * _Nullable errorMessage, NSDictionary * _Nullable extInfo) {
    };
    
    _livePlayer.onAnchorAvailable = ^(GSLLivePlayer *player, BOOL available, NSString * _Nonnull userId) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (available) {
            GSLLiveView *liveView = [[GSLLiveView alloc] initWithUserId:userId userType:GSLLiveViewUserType_Anchor livePlayer:player];
            [player startRemoteView:userId view:liveView];
            [player setRemoteViewFillMode:userId mode:GSLLiveVideoFillMode_Fit];
            
            LiveControlView *controlView = [[LiveControlView alloc] initWithView:liveView];
            [liveView addSubview:controlView];
        } else {
            [player stopRemoteView:userId];
        }
        [strongSelf viewDidLayoutSubviews];
    };
    
    _livePlayer.onAssistAvailable = ^(GSLLivePlayer *player, BOOL available, NSString * _Nonnull userId) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (available) {
            GSLLiveView *liveView = [[GSLLiveView alloc] initWithUserId:userId userType:GSLLiveViewUserType_Assist livePlayer:player];
            [player startRemoteSubStreamView:userId view:liveView];
            [player setRemoteSubStreamViewFillMode:userId mode:GSLLiveVideoFillMode_Fit];
        } else {
            [player stopRemoteSubStreamView:userId];
        }
        [strongSelf viewDidLayoutSubviews];
    };
    
    _livePlayer.onAudienceAvailable = ^(GSLLivePlayer *player, BOOL available, NSString * _Nonnull userId, BOOL banVideo, BOOL banAudio) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if ([userId isEqualToString:strongSelf->_liveUserId]) {
            if (available) {
                GSLLiveView *liveView = [[GSLLiveView alloc] initWithUserId:strongSelf->_liveUserId userType:GSLLiveViewUserType_Audience livePlayer:player];
                [player startLocalView:YES view:liveView];
                [player setLocalViewFillMode:GSLLiveVideoFillMode_Fit];
                [player startLocalAudio];
                // 设置禁音禁画状态
                liveView.banVideo = banVideo;
                liveView.banAudio = banAudio;
                
                LiveControlView *controlView = [[LiveControlView alloc] initWithView:liveView];
                [liveView addSubview:controlView];
            } else {
                [player stopLocalView];
                [player stopLocalAudio];
            }
        } else {
            if (available) {
                GSLLiveView *liveView = [[GSLLiveView alloc] initWithUserId:userId userType:GSLLiveViewUserType_Audience livePlayer:player];
                [player startRemoteView:userId view:liveView];
                [player setRemoteViewFillMode:userId mode:GSLLiveVideoFillMode_Fit];
                // 设置禁音禁画状态
                liveView.banVideo = banVideo;
                liveView.banAudio = banAudio;
                
                LiveControlView *controlView = [[LiveControlView alloc] initWithView:liveView];
                [liveView addSubview:controlView];
            } else {
                [player stopRemoteView:userId];
            }
        }
        [strongSelf viewDidLayoutSubviews];
    };
    
    _livePlayer.onAgreeConnectToAnchor = ^(GSLLivePlayer *player, BOOL banVideo, BOOL banAudio) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        GSLLiveView *liveView = [[GSLLiveView alloc] initWithUserId:strongSelf->_liveUserId userType:GSLLiveViewUserType_Audience livePlayer:strongSelf->_livePlayer];
        [player startLocalView:YES view:liveView];
        [player setLocalViewFillMode:GSLLiveVideoFillMode_Fit];
        [player startLocalAudio];
        // 设置禁音禁画状态
        liveView.banVideo = banVideo;
        liveView.banAudio = banAudio;
        
        LiveControlView *controlView = [[LiveControlView alloc] initWithView:liveView];
        [liveView addSubview:controlView];
        [strongSelf viewDidLayoutSubviews];
    };
    
    _livePlayer.onRefuseConnectToAnchor = ^(GSLLivePlayer * _Nonnull player) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf showMessage:@"主播拒绝了你的连麦申请"];
    };
    
    _livePlayer.onInviteConnectToAnchor = ^(GSLLivePlayer * _Nonnull player) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf onInviteConnectToAnchor];
    };
    
    _livePlayer.onBanVideo = ^(GSLLivePlayer * _Nonnull player, BOOL banVideo) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        GSLLiveView *subView = [player getCacheRemoteViewWithUserId:strongSelf->_liveUserId];
        if (subView) {
            subView.banVideo = banVideo;
        }
        [strongSelf showMessage:banVideo ? @"您已被主播禁画" : @"主播已解除您的禁画"];
    };
    
    _livePlayer.onBanAudio = ^(GSLLivePlayer * _Nonnull player, BOOL banAudio) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        GSLLiveView *subView = [player getCacheRemoteViewWithUserId:strongSelf->_liveUserId];
        if (subView) {
            subView.banAudio = banAudio;
        }
        [strongSelf showMessage:banAudio ? @"您已被主播禁音" : @"主播已解除您的禁音"];
    };
    
    _livePlayer.onAudienceBanVideo = ^(GSLLivePlayer * _Nonnull player, BOOL banVideo, NSString * _Nonnull userId) {
        GSLLiveView *subView = [player getCacheRemoteViewWithUserId:userId];
        subView.banVideo = banVideo;
    };
    
    _livePlayer.onAudienceBanAudio = ^(GSLLivePlayer * _Nonnull player, BOOL banAudio, NSString * _Nonnull userId) {
        GSLLiveView *subView = [player getCacheRemoteViewWithUserId:userId];
        subView.banAudio = banAudio;
    };
    
    _livePlayer.onDisconnectToAnchor = ^(GSLLivePlayer * _Nonnull player) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [player stopLocalView];
        [player stopLocalAudio];
        
        [strongSelf showMessage:@"您已被主播下麦"];
        
        [strongSelf viewDidLayoutSubviews];
    };
}

- (void)loadUI {
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.anchorView];
    [self.view addSubview:self.assistView];
    [self.view addSubview:self.remoteViewScrollView];
    
    UIBarButtonItem *myButton4 = [[UIBarButtonItem alloc] initWithTitle:@"断开连麦" style:UIBarButtonItemStylePlain target:self action:@selector(testClick4)];
    UIBarButtonItem *myButton3 = [[UIBarButtonItem alloc] initWithTitle:@"申请连麦" style:UIBarButtonItemStylePlain target:self action:@selector(testClick3)];
    UIBarButtonItem *myButton2 = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(testClick2)];
    UIBarButtonItem *myButton1 = [[UIBarButtonItem alloc] initWithTitle:@"切镜头" style:UIBarButtonItemStylePlain target:self action:@selector(testClick1)];
    self.navigationItem.rightBarButtonItems = @[myButton1, myButton2, myButton3, myButton4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenOrShowNavigationBar)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
}

- (void)showMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", message] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)hiddenOrShowNavigationBar {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (void)onInviteConnectToAnchor {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到主播连麦邀请" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self)weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝邀请" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf->_livePlayer refuseConnectToAnchor];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"接受邀请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [strongSelf->_livePlayer agreeConnectToAnchor];
    }]];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)testClick4 {
    [_livePlayer disConnectToAnchor];
}

- (void)testClick3 {
    [_livePlayer applyConnectToAnchor];
}

- (void)testClick2 {
    if (_previewView) {
        [_livePlayer stopLocalPreview];
        [_previewView removeFromSuperview];
        _previewView = nil;
    } else {
        _previewView = [[PreviewView alloc] initWithFrame:CGRectMake(0, 0, 150, 240)];
        _previewView.layer.borderColor = [UIColor grayColor].CGColor;
        _previewView.layer.borderWidth = .5f;
        _previewView.layer.masksToBounds = YES;
        [_previewView setCenter:self.view.center];
        [self.view addSubview:_previewView];
        [_livePlayer startLocalPreview:YES view:_previewView];
    }
}

- (void)testClick1 {
    if (_previewView) {
        [_livePlayer switchPreviewCamera];
    } else {
        [_livePlayer switchCamera];
    }
}

- (void)viewDidLayoutSubviews {
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat v_w = 0;
    CGFloat v_h = 0;
    CGFloat s_w = CGRectGetWidth(self.view.frame);
    CGFloat s_h = CGRectGetHeight(self.view.frame);
    
    if (s_w > s_h) {
        // 横屏
        v_w = s_w * assistView_rate_H;
        v_h = s_h;
        self.assistView.frame = CGRectMake(min_x, min_y, v_w, v_h);
        if (_livePlayer.assistView) {
            [_livePlayer.assistView setFrame:self.assistView.bounds];
            [self.assistView addSubview:_livePlayer.assistView];
        }
        
        min_x = v_w;
        v_w = s_w - min_x;
        v_h = v_w / 16.0 * 9.0;
        self.anchorView.frame = CGRectMake(min_x, min_y, v_w, v_h);
        if (_livePlayer.anchorView) {
            [_livePlayer.anchorView setFrame:self.anchorView.bounds];
            [self.anchorView addSubview:_livePlayer.anchorView];
        }
        
        min_y = v_h;
        v_h = s_h - v_h;
        self.remoteViewScrollView.frame = CGRectMake(min_x, min_y, v_w, v_h);
        self.remoteViewScrollView.contentSize = CGSizeMake(v_w, v_w / 16.0 * 9.0 * _livePlayer.remoteViews.count);
        float remote_start_y = 0;
        for (int i = 0; i < _livePlayer.remoteViews.count; i++) {
            GSLLiveView *subView = _livePlayer.remoteViews[i];
            [subView setFrame:CGRectMake(0, remote_start_y, v_w, v_w / 16.0 * 9.0)];
            [self.remoteViewScrollView addSubview:subView];
            remote_start_y = CGRectGetMaxY(subView.frame);
        }
    } else {
        // 竖屏
        v_w = s_w;
        v_h = s_h * assistView_rate_V;
        self.assistView.frame = CGRectMake(min_x, min_y, v_w, v_h);
        if (_livePlayer.assistView) {
            [_livePlayer.assistView setFrame:self.assistView.bounds];
            [self.assistView addSubview:_livePlayer.assistView];
        }
        
        min_y = v_h;
        v_w = s_w / 5.0 * 3.0;
        v_h = s_h - s_h * assistView_rate_V;
        self.anchorView.frame = CGRectMake(min_x, min_y, v_w, v_h);
        if (_livePlayer.anchorView) {
            [_livePlayer.anchorView setFrame:self.anchorView.bounds];
            [self.anchorView addSubview:_livePlayer.anchorView];
        }
        
        min_x = v_w;
        v_w = s_w - min_x;
        self.remoteViewScrollView.frame = CGRectMake(min_x, min_y, v_w, v_h);
        self.remoteViewScrollView.contentSize = CGSizeMake(v_w, v_w / 16.0 * 9.0 * _livePlayer.remoteViews.count);
        float remote_start_y = 0;
        for (int i = 0; i < _livePlayer.remoteViews.count; i++) {
            GSLLiveView *subView = _livePlayer.remoteViews[i];
            [subView setFrame:CGRectMake(0, remote_start_y, v_w, v_w / 16.0 * 9.0)];
            [self.remoteViewScrollView addSubview:subView];
            remote_start_y = CGRectGetMaxY(subView.frame);
        }
    }
    [self.assistView addSubview:self.assistLabel];
    [self.anchorView addSubview:self.anchorLabel];
    [self.remoteViewScrollView addSubview:self.audienceLabel];
}

#pragma mark- getter

- (UIView *)anchorView {
    if (!_anchorView) {
        _anchorView = [[UIView alloc] init];
        [_anchorView setBackgroundColor:[UIColor blackColor]];
        _anchorView.layer.borderColor = [UIColor whiteColor].CGColor;
        _anchorView.layer.borderWidth = .5f;
        _anchorView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] init];
        [label setText:@"主播"];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label sizeToFit];
        [label setCenter:CGPointMake(CGRectGetWidth(label.frame) / 2.0, CGRectGetHeight(label.frame) / 2.0)];
        [_anchorView addSubview:label];
    }
    return _anchorView;
}

- (UILabel *)anchorLabel {
    if (!_anchorLabel) {
        _anchorLabel = [[UILabel alloc] init];
        [_anchorLabel setText:@"主播"];
        [_anchorLabel setTextColor:[UIColor whiteColor]];
        [_anchorLabel setFont:[UIFont systemFontOfSize:10]];
        [_anchorLabel sizeToFit];
        [_anchorLabel setCenter:CGPointMake(CGRectGetWidth(_anchorLabel.frame) / 2.0, CGRectGetHeight(_anchorLabel.frame) / 2.0)];
    }
    return _anchorLabel;
}

- (UIView *)assistView {
    if (!_assistView) {
        _assistView = [[UIView alloc] init];
        [_assistView setBackgroundColor:[UIColor blackColor]];
        _assistView.layer.borderColor = [UIColor whiteColor].CGColor;
        _assistView.layer.borderWidth = .5f;
        _assistView.layer.masksToBounds = YES;
    }
    return _assistView;
}

- (UILabel *)assistLabel {
    if (!_assistLabel) {
        _assistLabel = [[UILabel alloc] init];
        [_assistLabel setText:@"辅助画面"];
        [_assistLabel setTextColor:[UIColor whiteColor]];
        [_assistLabel setFont:[UIFont systemFontOfSize:10]];
        [_assistLabel sizeToFit];
        [_assistLabel setCenter:CGPointMake(CGRectGetWidth(_assistLabel.frame) / 2.0, CGRectGetHeight(_assistLabel.frame) / 2.0)];
    }
    return _assistLabel;
}

- (UIScrollView *)remoteViewScrollView {
    if (!_remoteViewScrollView) {
        _remoteViewScrollView = [[UIScrollView alloc] init];
        [_remoteViewScrollView setBackgroundColor:[UIColor blackColor]];
        [_remoteViewScrollView setShowsHorizontalScrollIndicator:YES];
        [_remoteViewScrollView setShowsVerticalScrollIndicator:NO];
        _remoteViewScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
        _remoteViewScrollView.layer.borderWidth = .5f;
        _remoteViewScrollView.layer.masksToBounds = YES;
    }
    return _remoteViewScrollView;
}

- (UILabel *)audienceLabel {
    if (!_audienceLabel) {
        _audienceLabel = [[UILabel alloc] init];
        [_audienceLabel setText:@"观众"];
        [_audienceLabel setTextColor:[UIColor whiteColor]];
        [_audienceLabel setFont:[UIFont systemFontOfSize:10]];
        [_audienceLabel sizeToFit];
        [_audienceLabel setCenter:CGPointMake(CGRectGetWidth(_audienceLabel.frame) / 2.0, CGRectGetHeight(_audienceLabel.frame) / 2.0)];
    }
    return _audienceLabel;
}

- (void)showWarning:(NSString *)warning {
    UILabel *warningLabel = [[UILabel alloc] init];
    [warningLabel setText:warning];
    [warningLabel setTextAlignment:NSTextAlignmentCenter];
    [warningLabel setFont:[UIFont systemFontOfSize:14.f]];
    [warningLabel sizeToFit];
    [warningLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [warningLabel setTextColor:[UIColor blackColor]];
    
    
}

#pragma mark- viewControllerMethodes

//当旋转结束是时触发
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    GSLLiveVideoQosParam *qosParam = [[GSLLiveVideoQosParam alloc] init];
    qosParam.resolution = GSLLiveVideoResolution_640_360;
    if (size.width > size.height) {
        // 横屏
        qosParam.resolutionMode = GSLLiveVideoResolutionMode_landscape;
    } else {
        // 竖屏
        qosParam.resolutionMode = GSLLiveVideoResolutionMode_portrait;
    }
    qosParam.videoFps = test_videoFps;
    qosParam.videoBitrate = test_videoBitrate;
    [self->_livePlayer setVideoQosParam:qosParam];
}

#pragma mark- GSLSignalingCenterDelegate

/// 连接状态改变
/// @param center 信令中心
/// @param success YES：已连接 | NO：未连接
- (void)signalingCenter:(GSLSignalingCenter *)center connectSuccess:(BOOL)success {
    NSLog(@"******** 独立信令 connectSuccess %@", @(success));
    //尝试重连
    if (!success) {
        [center reconnect];
    }
}

/// 错误
/// @param center 信令中心
/// @param error 错误体
- (void)signalingCenter:(GSLSignalingCenter *)center onError:(NSError *)error {
    NSLog(@"******** 独立信令 onError %@", error);
}

/// 有用户进入房间
/// @param center 信令中心
/// @param userFlag 用户标识
/// @param groupFlag 组号
/// @param role 用户角色
/// @param body 消息体
- (void)signalingCenter:(GSLSignalingCenter *)center
             onUserJoin:(NSString *)userFlag
              groupFlag:(NSString *)groupFlag
                   role:(NSString *)role
                   body:(NSDictionary *)body {
    NSLog(@"******** 独立信令 onUserJoin %@", body);
}

/// 有用户退出房间
/// @param center 信令中心
/// @param userFlag 用户标识
/// @param groupFlag 组号
/// @param role 用户角色
/// @param body 消息体
- (void)signalingCenter:(GSLSignalingCenter *)center
            onUserLeave:(NSString *)userFlag
              groupFlag:(NSString *)groupFlag
                   role:(NSString *)role
                   body:(NSDictionary *)body {
    NSLog(@"******** 独立信令 onUserLeave %@", body);
}

/// 收到消息
/// @param center 信令中心
/// @param messageType 消息类型
/// @param body 消息体
- (void)signalingCenter:(GSLSignalingCenter *)center didReceiveMessageWithType:(GSLSignalingMessageType)messageType messageBody:(NSDictionary *)body {
    NSLog(@"******** 独立信令 didReceiveMessageWithType %@", body);
}

@end
