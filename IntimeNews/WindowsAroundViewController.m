//
//  WindowsAroundViewController.m
//  WFunNews
//
//  Created by AnarL on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import "WindowsAroundViewController.h"

@interface WindowsAroundViewController ()

@end

@implementation WindowsAroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsClassId = 6;
    self.currentPage = 1;
    [self isOnline];
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
