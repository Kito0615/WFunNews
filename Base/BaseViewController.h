//
//  BaseViewController.h
//  WFunNews
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "NewsModel.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "HexFromString.h"
#import "NewsDetailViewController.h"

static BOOL _netWorkChecked;

@interface BaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    AFHTTPRequestOperationManager * _requestManager;
    NSMutableArray * _newsArr;
    Reachability * _reachableManager;
    
}
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int newsClassId;
- (void)isOnline;

- (void)loadDataWithsid:(int)sid  withPage:(int)page;

@property (weak, nonatomic) IBOutlet UITableView *newsList;

@end
