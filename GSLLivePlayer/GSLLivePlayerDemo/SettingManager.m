//
//  SettingManager.m
//  GSLLivePlayer
//
//  Created by wangtong on 2019/7/25.
//  Copyright © 2019 wangtong. All rights reserved.
//

#import "SettingManager.h"

@implementation SettingManager

+ (id)shareManager {
    static SettingManager *__SettingManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __SettingManager = [[SettingManager alloc] init];
        /*
        __SettingManager.livePlayer_appId = @"1000002";
        __SettingManager.livePlayer_liveId = @"10206";
        __SettingManager.livePlayer_roomId = @"10221";
        __SettingManager.livePlayer_userId = @"test001";
        __SettingManager.livePlayer_token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTAwMDAwMiwicm9vbUlkIjoxMDIyMSwibGl2ZUlkIjoxMDIwNiwicGxheWJhY2tJZCI6bnVsbCwicm9sZSI6InN0dWRlbnQiLCJ1c2VyR3JvdXAiOiJhbGwiLCJ1c2VyRmxhZyI6InRlc3QwMDEiLCJ0b2tlbkV4cGlyZSI6MTU5Njc2NzUwNTEwNCwiaWF0IjoxNTY1MjMxNjEyfQ.ao2cbb2easmZ-i2Rvnx3r3-mSs1kw1_g7tVP28q9aq8";
        */
        /*
         __SettingManager.livePlayer_appId = @"1000001";
         __SettingManager.livePlayer_liveId = @"938";
         __SettingManager.livePlayer_roomId = @"832";
         __SettingManager.livePlayer_userId = @"test_ios";
         __SettingManager.livePlayer_token = @"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyRmxhZyI6InRlc3RfaW9zIiwicGxheWJhY2tJZCI6bnVsbCwicm9sZSI6InRlYWNoZXIiLCJ2aWRlb1VpZCI6bnVsbCwiYXBwSWQiOjEwMDAwMDEsInZpZGVvSWQiOm51bGwsInRva2VuRXhwaXJlIjozMzA5OTI1NTkyNDk2OCwidXNlckdyb3VwIjoiYWxsIiwibGl2ZUlkIjo5MzgsInJvb21JZCI6ODMyfQ.NOOAaivAOb8NT453TF14bfh_lMeztZVqXTbE4nWiGjA";
         */
        /*
         __SettingManager.livePlayer_appId = @"1000001";
         __SettingManager.livePlayer_liveId = @"1106";
         __SettingManager.livePlayer_roomId = @"988";
         __SettingManager.livePlayer_userId = @"test001";
         __SettingManager.livePlayer_token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTAwMDAwMSwicm9vbUlkIjo5ODgsImxpdmVJZCI6MTEwNiwicGxheWJhY2tJZCI6bnVsbCwicm9sZSI6InN0dWRlbnQiLCJ1c2VyR3JvdXAiOiJhbGwiLCJ1c2VyRmxhZyI6InRlc3QwMDEiLCJ0b2tlbkV4cGlyZSI6MTU5NjU5NzY2MTkwMCwiaWF0IjoxNTY1MDc4ODkwfQ.SWvFVFvFnvFh1slcL60LJIcj4oxTUCY8wf7C4g4P6-4";
         */
        /*
        __SettingManager.livePlayer_appId = @"1000001";
        __SettingManager.livePlayer_liveId = @"1106";
        __SettingManager.livePlayer_roomId = @"988";
        __SettingManager.livePlayer_userId = @"wangtong";
        __SettingManager.livePlayer_token = @"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyRmxhZyI6Indhbmd0b25nIiwicGxheWJhY2tJZCI6bnVsbCwicm9sZSI6InN0dWRlbnQiLCJ2aWRlb1VpZCI6bnVsbCwiYXBwSWQiOjEwMDAwMDEsInZpZGVvSWQiOm51bGwsInRva2VuRXhwaXJlIjoxNTk2MjUxODc3MTE3LCJ1c2VyR3JvdXAiOiJhbGwiLCJsaXZlSWQiOjExMDYsInJvb21JZCI6OTg4fQ.f1VOaHdk40tZtG7BdwXNPWOza-oMs2K_CM-fmMQNfrA";
        */
        /*
         __SettingManager.livePlayer_appId = @"1000001";
         __SettingManager.livePlayer_liveId = @"1106";
         __SettingManager.livePlayer_roomId = @"988";
         __SettingManager.livePlayer_userId = @"wangtong01";
         __SettingManager.livePlayer_token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTAwMDAwMSwicm9vbUlkIjo5ODgsImxpdmVJZCI6MTEwNiwicGxheWJhY2tJZCI6bnVsbCwicm9sZSI6InN0dWRlbnQiLCJ1c2VyR3JvdXAiOiJhbGwiLCJ1c2VyRmxhZyI6Indhbmd0b25nMDEiLCJ0b2tlbkV4cGlyZSI6MTU5NjUyMTM0OTM3MywiaWF0IjoxNTY0OTg1MzY0fQ.oA-nGBtPDhAvgLAaXGBoOhkjwLeNEb9fJzm_z4kVA78";
         */
        /*
         __SettingManager.livePlayer_appId = @"1000001";
         __SettingManager.livePlayer_liveId = @"1106";
         __SettingManager.livePlayer_roomId = @"988";
         __SettingManager.livePlayer_userId = @"wangtong02";
         __SettingManager.livePlayer_token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTAwMDAwMSwicm9vbUlkIjo5ODgsImxpdmVJZCI6MTEwNiwicGxheWJhY2tJZCI6bnVsbCwicm9sZSI6InN0dWRlbnQiLCJ1c2VyR3JvdXAiOiJhbGwiLCJ1c2VyRmxhZyI6Indhbmd0b25nMDIiLCJ0b2tlbkV4cGlyZSI6MTU5NjU5NzY2MTkwMCwiaWF0IjoxNTY1MDYxNjc4fQ.PYVPCgqJq20itN4wvXOGpeum3GKZJMfktsDhtroKqqk";
         */
    });
    return __SettingManager;
}

@end
