//
//  MyTestController.m
//  WFunNews
//
//  Created by AnarL on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define VERSION_URL @"https://itunes.apple.com/lookup?id=1048971626"
#define UPDATE_URL @"https://itunes.apple.com/us/app/zhi-ji-xin-wen/id1048971626?mt=8&uo=4"


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
    [self createControllers];
    self.tabBarController.tabBar.hidden = YES;
    
    
//    [self.tabBar removeFromSuperview];
}

- (void)createControllers
{
    NSArray * unSelectArr = @[ @"tabbar_picture",@"tabbar_news", @"tabbar_setting"];
    NSArray * selectArr = @[ @"tabbar_picture_hl",@"tabbar_news_hl", @"tabbar_setting_hl"];
    
    NSArray * titleArr = @[NSLocalizedString(@"Intime", nil), NSLocalizedString(@"Hot", nil), NSLocalizedString(@"Setting", nil)];
    
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

- (void)checkVersion
{
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_manager GET:VERSION_URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary * resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * resultsArr = [resultDict objectForKey:@"results"];
        
        NSDictionary * result = [resultsArr lastObject];
        
        NSString * appStoreVersion =  [result objectForKey:@"version"];
        
        NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if (![appStoreVersion isEqualToString:currentVersion]) {
            [[[UIAlertView alloc] initWithTitle:@"更新" message:@"发现新版本了，去更新吗？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil] show];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
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

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL * appStoreUrl = [NSURL URLWithString:UPDATE_URL];
        [[UIApplication sharedApplication] openURL:appStoreUrl];
    }
}

@end
