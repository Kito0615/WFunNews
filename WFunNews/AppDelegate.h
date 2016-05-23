//
//  AppDelegate.h
//  WFunNews
//
//  Created by AnarL on 15/10/12.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnarLController.h"
#import "MyTestController.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
//#import "UMSocialSinaHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "JPUSHService.h"
#import <KSCrash/KSCrashInstallationStandard.h>
#import "BaseViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MyTestController * _tabbarController;
}

@property (nonatomic, weak) BaseViewController * mainViewController;

@property (strong, nonatomic) UIWindow *window;


@end

