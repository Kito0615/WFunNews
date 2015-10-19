//
//  IntimeNewsViewController.h
//  WFunNews
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNavTabBarController.h"
#import "LatestViewController.h"
#import "ImportantViewController.h"
#import "PhoneViewController.h"
#import "PCViewController.h"
#import "MicrosoftViewController.h"
#import "WindowsAroundViewController.h"

@interface IntimeNewsViewController : UITabBarController
{
    NSArray * _titleArr;
    
    LatestViewController * _latestVC;
    ImportantViewController * _importantVC;
    PhoneViewController * _phoneVC;
    PCViewController * _pcVC;
    MicrosoftViewController * _microsoftVC;
    WindowsAroundViewController * _windowsAroundVC;
}

@end
