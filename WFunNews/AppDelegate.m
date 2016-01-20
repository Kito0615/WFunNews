//
//  AppDelegate.m
//  WFunNews
//
//  Created by AnarL on 15/10/12.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:2];
    // Override point for customization after application launch.
    
    [UMSocialData setAppKey:@"5613779167e58e0d200008c7"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1309410722" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialQQHandler setQQWithAppId:@"1104820983" appKey:@"77cil6x3qIJtIJnK" url:@"http://bbs.wfun.com"];
    [UMSocialWechatHandler setWXAppId:@"wx225a5e952bc8c22f" appSecret:@"64ece97d5cc3c4b85a87dcb926194b52" url:@"http://bbs.wfun.com"];
    
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    
    _tabbarController = [[MyTestController alloc] init];
    _window.rootViewController = _tabbarController;
    
    [_window makeKeyAndVisible];
    
#if 0
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    // Required
    [APService setupWithOption:launchOptions];
    
    
    KSCrashInstallationStandard * installation = [KSCrashInstallationStandard sharedInstance];
    installation.url = [NSURL URLWithString:@"https://collector.bughd.com/kscrash?key=f579f5f4db3d3d46612a40b4d06e66bb"];
    [installation install];
    [installation sendAllReportsWithCompletion:nil];
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString * pushString = [[NSUserDefaults standardUserDefaults] objectForKey:@"Push"];
    
    if ([pushString isEqualToString:@"True"]) {
        
        NSDictionary * aps = [userInfo valueForKey:@"aps"];
        NSString * notificationContent = [aps valueForKey:@"alert"];
        
        [self.mainViewController showNotificationNews:notificationContent];
        
        [APService handleRemoteNotification:userInfo];
    } else {
        NSLog(@"Push Off");
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString * pushString = [[NSUserDefaults standardUserDefaults] objectForKey:@"Push"];
    
    if ([pushString isEqualToString:@"True"]) {
        [APService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        NSLog(@"Push Off");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [application setApplicationIconBadgeNumber:0];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
