//
//  AnarLController.h
//  SinaNews
//
//  Created by AnarL on 15/9/15.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnarLTabBar.h"
//#import "HotNewsController.h"
//#import "SettingController.h"

@interface AnarLController : UITabBarController <AnarTabBarDelegate>
{
    UIViewController * _hotNewsVC;
    UIViewController * _settingVC;
}

@end
