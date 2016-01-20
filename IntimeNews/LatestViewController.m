//
//  LatestViewController.m
//  WFunNews
//
//  Created by AnarL on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import "LatestViewController.h"

@interface LatestViewController ()

@end

@implementation LatestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsClassId = 0;
    self.currentPage = 1;
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.mainViewController = self;
    
    [self isOnline];
}


- (void)showNotificationNews:(NSString *)newsTitle
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    for (int index = 0; index < _newsArr.count; index ++) {
        NewsModel * news = _newsArr[index];
        if ([news.newsTitle isEqualToString:newsTitle]) {
            [self.newsList selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

@end
