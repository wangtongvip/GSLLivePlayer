//
//  LogViewController.m
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/25.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import "LogViewController.h"
#import <MessageUI/MessageUI.h>

@interface LogViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *logTV;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *logPath = [documentPath stringByAppendingPathComponent:@"/GSL.logData/logData.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        self.logTV.text = [NSString stringWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:nil];
    }
}

- (IBAction)scrollToBottom:(id)sender {
    [_logTV scrollRangeToVisible:NSMakeRange(_logTV.text.length, 1)];
}

- (IBAction)scrollToTop:(id)sender {
    [_logTV scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (IBAction)downloadLogAction:(id)sender {
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请设置系统的邮箱账户" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        [self.navigationController presentViewController:alert animated:YES completion:^{
        }];
        return;
    }
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"iOS视频直播SDK_TEST_LOG"];
    [mc setMessageBody:@"<HTML><B>连麦SDK_TEST_LOG</B><BR/>Copyright @gaosiedu.com</HTML>"
                isHTML:YES];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *logPath = [documentPath stringByAppendingPathComponent:@"/GSL.logData/logData.txt"];
    NSData *data = [NSData dataWithContentsOfFile:logPath];
    [mc addAttachmentData:data mimeType:@"" fileName:@"logData.txt"];
    [self.navigationController presentViewController:mc animated:YES completion:^{
    }];
}

- (IBAction)cleanLogAction:(id)sender {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *logPath = [documentPath stringByAppendingPathComponent:@"/GSL.logData/logData.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
        self.logTV.text = @"";
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: {
            NSLog(@"Mail sent...");
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
