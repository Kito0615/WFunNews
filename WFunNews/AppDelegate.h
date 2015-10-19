//
//  AppDelegate.h
//  WFunNews
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnarLController.h"
#import "MyTestController.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MyTestController * _tabbarController;
}

@property (strong, nonatomic) UIWindow *window;


@end

