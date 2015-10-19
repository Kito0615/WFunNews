//
//  AnarLController.h
//  SinaNews
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnarLTabBar.h"
#import "IntimeNewsViewController.h"
//#import "HotNewsController.h"
//#import "SettingController.h"

@interface AnarLController : UITabBarController <AnarTabBarDelegate>
{
    IntimeNewsViewController * _newsVC;
    UIViewController * _hotNewsVC;
    UIViewController * _settingVC;
}

@end