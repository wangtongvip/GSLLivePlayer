//
//  LiveControlView.m
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/19.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import "LiveControlView.h"

@interface LiveControlView () {
    GSLLiveView *_liveView;
    
    UIView *_coverView;         // 覆盖视图
    
    UILabel *_descriptionLabel; // 标题描述
    UILabel *_videoQosLabel;    // 音频质量
    UILabel *_audeoQosLabel;    // 视频质量
    UILabel *_muteVideoLabel;   // 视频质量
    UILabel *_muteAudioLabel;   // 视频质量
    UILabel *_banVideoLabel;    // 视频质量
    UILabel *_banAudioLabel;    // 视频质量
    
    UIButton *_muteVideoButton; // 静音按钮
    UIButton *_muteAudioButton; // 静画按钮
    
    UIButton *_showControlButton; // 控制面板展示按钮
}

@end

@implementation LiveControlView

- (instancetype)initWithView:(GSLLiveView *)view {
    self = [super init];
    if (self) {
        _liveView = view;
        for (UIView *subView in _liveView.subviews) {
            if ([subView isKindOfClass:[LiveControlView class]]) {
                [subView removeFromSuperview];
            }
        }
        [self loadUI];
        [self registLiveViewAction];
    }
    return self;
}

- (void)loadUI {
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.descriptionLabel];
    [self.descriptionLabel setText:[NSString stringWithFormat:@"______%@:%@", _liveView.isCurrentUser ? @"当前用户" : @"远端用户", _liveView.userId]];
    [self.coverView addSubview:self.videoQosLabel];
    [self.videoQosLabel setText:@""];
    [self.coverView addSubview:self.audeoQosLabel];
    [self.audeoQosLabel setText:@""];
    [self.coverView addSubview:self.muteVideoLabel];
    [self.muteVideoLabel setText:_liveView.muteVideo ? @"已静画" : @"未静画"];
    [self.coverView addSubview:self.muteAudioLabel];
    [self.muteAudioLabel setText:_liveView.muteAudio ? @"已静音" : @"未静音"];
    [self.coverView addSubview:self.banVideoLabel];
    [self.banVideoLabel setText:_liveView.banVideo ? @"已禁画" : @"未禁画"];
    [self.coverView addSubview:self.banAudioLabel];
    [self.banAudioLabel setText:_liveView.banAudio ? @"已禁音" : @"未禁音"];
    [self.coverView addSubview:self.muteVideoButton];
    [self.muteVideoButton setTitle:_liveView.muteVideo ? @"停止静画" : @"静画" forState:UIControlStateNormal];
    [self.coverView addSubview:self.muteAudioButton];
    [self.muteAudioButton setTitle:_liveView.muteAudio ? @"停止静音" : @"静音" forState:UIControlStateNormal];
    [self addSubview:self.showControlButton];
    [self.showControlButton setTitle:_coverView.hidden ? @"展示面板" : @"隐藏面板" forState:UIControlStateNormal];
}

- (void)registLiveViewAction {
    __weak typeof(self)weakSelf = self;
    _liveView.onBanVideo = ^(GSLLiveView * _Nonnull liveView, BOOL ban) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.banVideoLabel setText:ban ? @"已禁画" : @"未禁画"];
    };
    _liveView.onBanAudio = ^(GSLLiveView * _Nonnull liveView, BOOL ban) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.banAudioLabel setText:ban ? @"已禁音" : @"未禁音"];
    };
    _liveView.onAudioQualityChanged = ^(GSLLiveView * _Nonnull liveView, float AudioQuality) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.audeoQosLabel setText:[NSString stringWithFormat:@"音量：%f",AudioQuality]];
    };
    _liveView.onVideoQualityChanged = ^(GSLLiveView * _Nonnull liveView, GSLLiveQuality videoQuality) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.videoQosLabel setText:[NSString stringWithFormat:@"视频质量：%@",@(videoQuality)]];
    };
}

- (void)layoutSubviews {
    if (self.superview) {
        self.frame = self.superview.bounds;
    }
    self.coverView.frame = self.bounds;
    self.descriptionLabel.center = CGPointMake(CGRectGetWidth(self.descriptionLabel.frame) / 2.f, CGRectGetHeight(self.descriptionLabel.frame) / 2.f);
    self.videoQosLabel.center = CGPointMake(CGRectGetWidth(self.videoQosLabel.frame) / 2.f, CGRectGetMaxY(self.descriptionLabel.frame) + CGRectGetHeight(self.videoQosLabel.frame) / 2.f);
    self.audeoQosLabel.center = CGPointMake(CGRectGetWidth(self.audeoQosLabel.frame) / 2.f, CGRectGetMaxY(self.videoQosLabel.frame) + CGRectGetHeight(self.audeoQosLabel.frame) / 2.f);
    self.muteVideoLabel.center = CGPointMake(CGRectGetWidth(self.muteVideoLabel.frame) / 2.f, CGRectGetMaxY(self.audeoQosLabel.frame) + CGRectGetHeight(self.muteVideoLabel.frame) / 2.f);
    self.muteAudioLabel.center = CGPointMake(CGRectGetWidth(self.muteAudioLabel.frame) / 2.f, CGRectGetMaxY(self.muteVideoLabel.frame) + CGRectGetHeight(self.muteAudioLabel.frame) / 2.f);
    self.banVideoLabel.center = CGPointMake(CGRectGetWidth(self.banVideoLabel.frame) / 2.f, CGRectGetMaxY(self.muteAudioLabel.frame) + CGRectGetHeight(self.banVideoLabel.frame) / 2.f);
    self.banAudioLabel.center = CGPointMake(CGRectGetWidth(self.banAudioLabel.frame) / 2, CGRectGetMaxY(self.banVideoLabel.frame) + CGRectGetHeight(self.banAudioLabel.frame) / 2);
    self.muteVideoButton.center = CGPointMake(CGRectGetWidth(self.coverView.frame) / 2.f - 1 - CGRectGetWidth(self.muteVideoButton.frame) / 2.f, CGRectGetHeight(self.coverView.frame) / 2.f);
    self.muteAudioButton.center = CGPointMake(CGRectGetMaxX(self.muteVideoButton.frame) + 2 + CGRectGetWidth(self.muteAudioButton.frame) / 2.f, self.muteVideoButton.center.y);
    self.showControlButton.center = CGPointMake(CGRectGetWidth(self.coverView.frame) - CGRectGetWidth(self.showControlButton.frame) / 2.f, CGRectGetHeight(self.showControlButton.frame) / 2.f);
}

#pragma mark- method

- (void)muteVideoAction:(UIButton *)sender {
    _liveView.muteVideo = !_liveView.muteVideo;
    [self.muteVideoLabel setText:_liveView.muteVideo ? @"已静画" : @"未静画"];
    [self.muteVideoButton setTitle:_liveView.muteVideo ? @"停止静画" : @"静画" forState:UIControlStateNormal];
    
    if (_liveView.muteVideo && _liveView.isCurrentUser) {
        [self showMessage:@"已停止向远端用户展示您的实时画面"];
    }
}

- (void)muteAudioAction:(UIButton *)sender {
    _liveView.muteAudio = !_liveView.muteAudio;
    [self.muteAudioLabel setText:_liveView.muteAudio ? @"已静音" : @"未静音"];
    [self.muteAudioButton setTitle:_liveView.muteAudio ? @"停止静音" : @"静音" forState:UIControlStateNormal];
    
    if (_liveView.muteAudio && _liveView.isCurrentUser) {
        [self showMessage:@"远端用户已听不到您的声音"];
    }
}

- (void)showControlAction:(UIButton *)sender {
    _coverView.hidden = !_coverView.hidden;
    [self.showControlButton setTitle:_coverView.hidden ? @"展示面板" : @"隐藏面板" forState:UIControlStateNormal];
}

- (void)showMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", message] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
    }];
}

#pragma mark- getter

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        [_coverView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [_coverView setClipsToBounds:YES];
    }
    return _coverView;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [self creatLabel];
    }
    return _descriptionLabel;
}

- (UILabel *)videoQosLabel {
    if (!_videoQosLabel) {
        _videoQosLabel = [self creatLabel];
    }
    return _videoQosLabel;
}

- (UILabel *)audeoQosLabel {
    if (!_audeoQosLabel) {
        _audeoQosLabel = [self creatLabel];
    }
    return _audeoQosLabel;
}

- (UILabel *)muteVideoLabel {
    if (!_muteVideoLabel) {
        _muteVideoLabel = [self creatLabel];
    }
    return _muteVideoLabel;
}

- (UILabel *)muteAudioLabel {
    if (!_muteAudioLabel) {
        _muteAudioLabel = [self creatLabel];
    }
    return _muteAudioLabel;
}

- (UILabel *)banVideoLabel {
    if (!_banVideoLabel) {
        _banVideoLabel = [self creatLabel];
    }
    return _banVideoLabel;
}

- (UILabel *)banAudioLabel {
    if (!_banAudioLabel) {
        _banAudioLabel = [self creatLabel];
    }
    return _banAudioLabel;
}

- (UIButton *)muteVideoButton {
    if (!_muteVideoButton) {
        _muteVideoButton = [self creatButton];
        [_muteVideoButton addTarget:self action:@selector(muteVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteVideoButton;
}

- (UIButton *)muteAudioButton {
    if (!_muteAudioButton) {
        _muteAudioButton = [self creatButton];
        [_muteAudioButton addTarget:self action:@selector(muteAudioAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteAudioButton;
}

- (UIButton *)showControlButton {
    if (!_showControlButton) {
        _showControlButton = [self creatButton];
        [_showControlButton addTarget:self action:@selector(showControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showControlButton;
}

- (UIButton *)creatButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"占位占位" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3f]];
    [button sizeToFit];
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = .5f;
    button.layer.cornerRadius = 3.f;
    button.layer.masksToBounds = YES;
    
    return button;
}

- (UILabel *)creatLabel {
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"占位占位占位占位占位占位占位占位占位"];
    [label setFont:[UIFont systemFontOfSize:10.f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label sizeToFit];
    
    return label;
}

@end
