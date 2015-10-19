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
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger newsClassId;
- (void)isOnline;

- (void)loadDataWithsid:(NSInteger)sid  withPage:(NSInteger)page;

@property (weak, nonatomic) IBOutlet UITableView *newsList;

@end
