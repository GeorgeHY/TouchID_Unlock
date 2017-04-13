//
//  ViewController.m
//  TouchIDDemo
//
//  Created by 韩扬 on 2017/4/13.
//  Copyright © 2017年 HanYang. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"请按home键指纹解锁";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        //支持指纹识别
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    NSLog(@"验证成功");
                                } else {
                                    NSLog(@"验证失败");
                                    switch (error.code) {
                                        case LAErrorSystemCancel:
                                        {
                                            NSLog(@"系统取消授权，如其他APP切入");
                                            break;
                                        }
                                        case LAErrorUserCancel:
                                        {
                                            NSLog(@"用户取消验证Touch ID");
                                            break;
                                        }
                                        case LAErrorAuthenticationFailed:
                                        {
                                            NSLog(@"授权失败");
                                            break;
                                        }
                                        case LAErrorPasscodeNotSet:
                                        {
                                            NSLog(@"系统未设置密码");
                                            break;
                                        }
                                        case LAErrorTouchIDNotAvailable:
                                        {
                                            NSLog(@"设备Touch ID不可用，例如未打开");
                                            break;
                                        }
                                        case LAErrorTouchIDNotEnrolled:
                                        {
                                            NSLog(@"设备Touch ID不可用，用户未录入");
                                            break;
                                        }
                                        case LAErrorUserFallback:
                                        {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                NSLog(@"用户选择输入密码，切换主线程处理");
                                            }];
                                            break;
                                        }
                                        default:
                                        {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                NSLog(@"其他情况，切换主线程处理");
                                            }];
                                            break;
                                        }
                                    }
                                }
                            }];
    } else {
        NSLog(@"不支持指纹识别");
        switch (authError.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"设备Touch ID不可用，用户未录入");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"系统未设置密码");
                break;
            }
            case LAErrorTouchIDNotAvailable:
            {
                NSLog(@"设备Touch ID不可用，例如未打开");
                break;
            }
            default:
            {
                NSLog(@"系统未设置密码");
                break;
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
