//
//  IntimeNewsViewController.m
//  WFunNews
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

#import "IntimeNewsViewController.h"

@interface IntimeNewsViewController ()

@end

@implementation IntimeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleArr = @[@"最新", @"重要", @"手机", @"电脑", @"微软", @"周边"];
    [self createViewControllers];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏系统导航栏
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

- (void)createViewControllers
{
    
    NSMutableArray * controllers = [[NSMutableArray alloc] init];
    
    _latestVC = [[LatestViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
    _latestVC.title = _titleArr[0];
    [controllers addObject:_latestVC];
    
    _importantVC = [[ImportantViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
    _importantVC.title = _titleArr[1];
    [controllers addObject:_importantVC];
    
    _phoneVC = [[PhoneViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
    _phoneVC.title = _titleArr[2];
    [controllers addObject:_phoneVC];
    
    _pcVC = [[PCViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
    _pcVC.title = _titleArr[3];
    [controllers addObject:_pcVC];
    
    _microsoftVC = [[MicrosoftViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
    _microsoftVC.title = _titleArr[4];
    [controllers addObject:_microsoftVC];
    
    _windowsAroundVC = [[WindowsAroundViewController alloc] initWithNibName:@"BaseViewController" bundle:nil];
    _windowsAroundVC.title = _titleArr[5];
    [controllers addObject:_windowsAroundVC];
    
    
    SCNavTabBarController * scNav = [[SCNavTabBarController alloc] init];
    [scNav setNavTabBarColor:COLORWITHRGB(240, 97, 102)];
    [scNav setNavTabBarLineColor:[UIColor greenColor]];
    
    self.view.backgroundColor = COLORWITHRGB(240, 97, 102);
    
    
    scNav.subViewControllers = [NSArray arrayWithArray:controllers];
    [scNav addParentController:self];
    scNav.tabBarController.tabBar.hidden = YES;
}

#pragma mark -设置当前页面状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
