//
//  SettingViewController.m
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/3.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingManager.h"

@interface SettingViewController ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *_users;
    UIPickerView *_selectPicker;
}

@property (weak, nonatomic) IBOutlet UITextField *appIdTF;
@property (weak, nonatomic) IBOutlet UITextField *liveIdTF;
@property (weak, nonatomic) IBOutlet UITextField *roomIdTF;
@property (weak, nonatomic) IBOutlet UITextField *userIdTF;
@property (weak, nonatomic) IBOutlet UITextField *tokenTF;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    _appIdTF.text = [[SettingManager shareManager] livePlayer_appId];
    _liveIdTF.text = [[SettingManager shareManager] livePlayer_liveId];
    _roomIdTF.text = [[SettingManager shareManager] livePlayer_roomId];
    _userIdTF.text = [[SettingManager shareManager] livePlayer_userId];
    _tokenTF.text = [[SettingManager shareManager] livePlayer_token];
     */
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.selectPicker setFrame:self.view.bounds];
}

- (IBAction)setAction:(id)sender {
    [[SettingManager shareManager] setLivePlayer_appId:_appIdTF.text];
    [[SettingManager shareManager] setLivePlayer_liveId:_liveIdTF.text];
    [[SettingManager shareManager] setLivePlayer_roomId:_roomIdTF.text];
    [[SettingManager shareManager] setLivePlayer_userId:_userIdTF.text];
    [[SettingManager shareManager] setLivePlayer_token:_tokenTF.text];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"参数已经更新" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了，谢谢" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:^{
    }];
}

- (IBAction)selectParams:(id)sender {
    if (self.selectPicker.superview) {
        [self.selectPicker removeFromSuperview];
    } else {
        if ([self loadJsonConfig]) {
            [self.view addSubview:self.selectPicker];
        }
    }
}

- (BOOL)loadJsonConfig {
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"paramsConfiguration" ofType:@"json"];
    if (configPath == nil) return NO;
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:configPath];
    [stream open];
    NSError *error = nil;
    NSDictionary *config = [NSJSONSerialization JSONObjectWithStream:stream options:0 error:&error];
    [stream close];
    if (config == nil) {
        NSLog(@"Error when loading config at %@: %@", configPath, error);
        return NO;
    }
    _users = [NSArray arrayWithArray:config[@"users"]];
    return YES;
}

#pragma mark- getter

- (UIPickerView *)selectPicker {
    if (!_selectPicker) {
        _selectPicker = [[UIPickerView alloc] initWithFrame:self.view.frame];
        _selectPicker.delegate = self;
        _selectPicker.dataSource = self;
        [_selectPicker setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.9f]];
    }
    return _selectPicker;
}

#pragma mark - UIPickerView DataSource and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_users count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 46;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _users[row][@"userId"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _appIdTF.text = [NSString stringWithFormat:@"%@", _users[row][@"appId"]];
    _liveIdTF.text = [NSString stringWithFormat:@"%@", _users[row][@"liveId"]];
    _roomIdTF.text = [NSString stringWithFormat:@"%@", _users[row][@"roomId"]];
    _userIdTF.text = [NSString stringWithFormat:@"%@", _users[row][@"userId"]];
    _tokenTF.text = [NSString stringWithFormat:@"%@", _users[row][@"userToken"]];
    
    [self.selectPicker removeFromSuperview];
}

@end
