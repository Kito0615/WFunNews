//
//  LatestViewController.m
//  WFunNews
//
//  Created by qianfeng on 15/10/13.
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
    
    [self isOnline];
}


@end
