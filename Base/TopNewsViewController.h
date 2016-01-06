//
//  TopNewsViewController.h
//  WFunNews
//
//  Created by AnarL on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NewsCell.h"
#import "HexFromString.h"
#import "NewsDetailViewController.h"
#import "Reachability.h"
#import "MJRefresh.h"
#import "NewsModel.h"
#import "MBProgressHUD.h"

@interface TopNewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    AFHTTPRequestOperationManager * _requestManager;
    NSMutableArray * _topNewsArr;
    BOOL _topDaySectionOpen;
    BOOL _topWeekSectionOpen;
    BOOL _topMonthSectionOpen;
    
    Reachability * _reachableManager;
}
@property (weak, nonatomic) IBOutlet UITableView *newsListView;

@end
