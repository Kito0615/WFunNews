//
//  MyTestController.m
//  WFunNews
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]


#import "MyTestController.h"
#import "IntimeNewsViewController.h"
#import "TopNewsViewController.h"
#import "SettingViewController.h"

@interface MyTestController ()

@end

@implementation MyTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self createControllers];
    
//    [self.tabBar removeFromSuperview];
}

- (void)createControllers
{
    NSArray * unSelectArr = @[ @"tabbar_picture",@"tabbar_news", @"tabbar_setting"];
    NSArray * selectArr = @[ @"tabbar_picture_hl",@"tabbar_news_hl", @"tabbar_setting_hl"];
    
    NSArray * titleArr = @[@"即时新闻",@"热点新闻",@"系统设置"];
    
    NSMutableArray * controllersArr = [[NSMutableArray alloc] init];
    
    IntimeNewsViewController * intimeVC = [[IntimeNewsViewController alloc] init];
    intimeVC.title = titleArr[0];
    UINavigationController * intimeNC = [[UINavigationController alloc] initWithRootViewController:intimeVC];
    intimeNC.tabBarItem.image = [UIImage imageNamed:unSelectArr[0]];
    intimeNC.tabBarItem.selectedImage = [UIImage imageNamed:selectArr[0]];
    [intimeNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORWITHRGB(240, 97, 102)} forState:UIControlStateSelected];
    [controllersArr addObject:intimeNC];
    
    
    TopNewsViewController * topNewsVC = [[TopNewsViewController alloc] init];
    topNewsVC.title = titleArr[1];
    UINavigationController * topNewsNC = [[UINavigationController alloc] initWithRootViewController:topNewsVC];
    topNewsNC.tabBarItem.image = [UIImage imageNamed:unSelectArr[1]];
    topNewsNC.tabBarItem.selectedImage = [UIImage imageNamed:selectArr[1]];
    [topNewsNC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORWITHRGB(240, 97, 102)} forState:UIControlStateSelected];
    [controllersArr addObject:topNewsNC];
    
    SettingViewController * settingVC = [[SettingViewController alloc] init];
    settingVC.title = titleArr[2];
    settingVC.tabBarItem.image = [UIImage imageNamed:unSelectArr[2]];
    settingVC.tabBarItem.selectedImage = [UIImage imageNamed:selectArr[2]];
    [settingVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORWITHRGB(240, 97, 102)} forState:UIControlStateSelected];
    [controllersArr addObject:settingVC];

    self.viewControllers = controllersArr;
    [self.tabBar setTintColor:COLORWITHRGB(240, 97, 102)];
    
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
