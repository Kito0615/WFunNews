//
//  BaseViewController.m
//  WFunNews
//
//  Created by AnarL on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define BASE_URL @"http://api.wpxap.com/news/all?rows=20&app=anar0615&code=cn"

#define COLOR_WITH_RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


#import "BaseViewController.h"
#import "NewsCell.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _newsArr = [[NSMutableArray alloc] init];
    
    self.newsList.dataSource = self;
    self.newsList.delegate = self;
    [self.newsList registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
    self.newsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsList.backgroundColor = COLOR_WITH_RGB(239, 239, 239);
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self pullToRefresh];
    [self pullToLoadMore];
}
- (void)isOnline
{
    _reachableManager = [Reachability reachabilityWithHostName:@"bbs.wfun.com"];
    switch (_reachableManager.currentReachabilityStatus) {
        case ReachableViaWiFi:
            
            [self loadFromLocal];
            [self.newsList reloadData];
            [self loadDataWithsid:self.newsClassId withPage:self.currentPage];
            
            break;
        case ReachableViaWWAN:
            
            [self loadFromLocal];
            [self.newsList reloadData];
            [self loadDataWithsid:self.newsClassId withPage:self.currentPage];
            
            break;
        case NotReachable:
            
            if (!_netWorkChecked) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"Network", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles:nil] show];
                _netWorkChecked = YES;
            }
            [self loadFromLocal];
            
            break;
            
        default:
            break;
    }
}

- (void)loadFromLocal
{
    NSData * newsData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"news%d", self.newsClassId]];
    [_newsArr removeAllObjects];
    [_newsArr addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:newsData]];
    [self.newsList reloadData];
    
    [self.newsList.header endRefreshing];
    [self.newsList.footer endRefreshing];
    
    NSLog(@"load successed!");
}


- (void)saveToLocal
{
    
    NSData * newsData = [NSKeyedArchiver archivedDataWithRootObject:_newsArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:newsData forKey:[NSString stringWithFormat:@"news%d", self.newsClassId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"save successed!");
    
}

- (void)loadDataWithsid:(int)sid  withPage:(int)page
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _requestManager = [AFHTTPRequestOperationManager manager];
    _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", BASE_URL, [NSString stringWithFormat:@"&sid=%d&page=%d", sid,page]]);
    
    [_requestManager GET:[NSString stringWithFormat:@"%@%@", BASE_URL, [NSString stringWithFormat:@"&sid=%d&page=%d", sid,page]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (_currentPage == 1) {
            [_newsArr removeAllObjects];
        }
        NSArray * listArr = responseData[@"results"];
        for (NSDictionary * newsDict in listArr) {
            NewsModel * model = [[NewsModel alloc] initWithDict:newsDict];
            [_newsArr addObject:model];
        }
        
        [self.newsList reloadData];
        
        if (_newsArr.count == 20) {
            self.newsList.contentOffset = CGPointMake(0, 0);
        }
        
        [self.newsList.header endRefreshing];
        [self.newsList.footer endRefreshing];
        [hud hide:YES];
        [self saveToLocal];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}



#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsArr.count > 0 ? _newsArr.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    NewsModel * model = [_newsArr objectAtIndex:indexPath.row];
    
    [cell.newsPic sd_setImageWithURL:[NSURL URLWithString:model.newsPicUrl] placeholderImage:[UIImage imageNamed:@"imgpholder"]];
    cell.newsTitle.text = model.newsTitle;
    cell.newsInfo.text = [NSString stringWithFormat:@"分类:%@ | 热度:%ld/%ld | %@", model.newsClassName, model.newsReplies.integerValue, model.newsViewers.integerValue, model.newsDateLine];
    if (model.newsRecommend.integerValue != 0) {
        HexFromString * hex = [[HexFromString alloc] init];
        
        NSArray * colorValueArr = [hex RGBWithHexString:model.newsHighLight];
        
        NSInteger redValue = [colorValueArr[0] integerValue];
        NSInteger greenValue = [colorValueArr[1] integerValue];
        NSInteger blueValue = [colorValueArr[2] integerValue];
        
        cell.newsTitle.textColor = COLOR_WITH_RGB(redValue, greenValue, blueValue);
        
    } else {
        cell.newsTitle.textColor = [UIColor blackColor];
    }
    
    cell.newsSummary.text = model.newsSummary;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark -UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsDetailViewController * ndvc = [[NewsDetailViewController alloc] init];
    NewsModel * model = _newsArr[indexPath.row];
    ndvc.model = model;
    
    ndvc.newsTitleString = model.newsTitle;
    NSDate * newsDate = [NSDate dateWithTimeIntervalSince1970:[model.newsDBDateLine floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    
    ndvc.newsInfoString = [NSString stringWithFormat:@"%@ | %@", [df stringFromDate:newsDate], model.newsAuthorName];
    
    ndvc.webUrl = [NSString stringWithFormat:@"%@%@", model.newsAPIUrl, @"&app=anar0615"];
    ndvc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController.navigationBar setHidden:NO];
    
    
    [self.navigationController pushViewController:ndvc animated:YES];
    
}

#pragma mark -上拉加载更多
- (void)pullToLoadMore
{
    self.newsList.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.currentPage ++;
        [self loadDataWithsid:self.newsClassId withPage:self.currentPage];
        
    }];
}

#pragma mark -下拉刷新当前
- (void)pullToRefresh
{
    self.newsList.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _netWorkChecked = NO;
        self.currentPage = 1;
        [self isOnline];
    }];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showNotificationNews:(NSString *)newsTitle
{

}
@end
