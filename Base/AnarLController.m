//
//  AnarLController.m
//  SinaNews
//
//  Created by AnarL on 15/9/15.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import "AnarLController.h"
#import "IntimeNewsViewController.h"

@interface AnarLController ()
{
    IntimeNewsViewController * _newsVC;
}

@end

@implementation AnarLController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AnarLTabBar * myTabbar = [[AnarLTabBar alloc] init];
    myTabbar.frame = self.tabBar.bounds;
    myTabbar.delegate = self;
    
    [self createNavigationControllers];
    
    [self.tabBar addSubview:myTabbar];
    
//    [self.tabBar removeFromSuperview];
}


- (void)createNavigationControllers
{
    _newsVC = [[IntimeNewsViewController alloc] init];
    UINavigationController * _newsNC = [[UINavigationController alloc] initWithRootViewController:_newsVC];
    
    _hotNewsVC = [[UIViewController alloc] init];
    UINavigationController * hotNewsNC = [[UINavigationController alloc] initWithRootViewController:_hotNewsVC];
    
    _settingVC = [[UIViewController alloc] init];
//    UINavigationController * settingNC = [[UINavigationController alloc] initWithRootViewController:_settingVC];
    
    NSArray * controllers = @[_newsNC, hotNewsNC, _settingVC];
    
    self.viewControllers = controllers;
    
}

-(void)tabBar:(AnarLTabBar *)tabbar didselectButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end