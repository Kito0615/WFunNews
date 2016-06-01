//
//  TopNewsViewController.m
//  WFunNews
//
//  Created by AnarL on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define HOT_NEWS_URL @"http://api.wpxap.com/news/all?top_day=10&top_week=10&top_moon=10"
#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

#import "TopNewsViewController.h"

#import "NewsContentViewController.h"

@interface TopNewsViewController ()

@end

@implementation TopNewsViewController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.newsListView.delegate = self;
    self.newsListView.dataSource = self;
    [self.newsListView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
    self.newsListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newsListView.backgroundColor = COLORWITHRGB(231, 231, 231);
    
    _topNewsArr = [[NSMutableArray alloc] init];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLORWITHRGB(255, 255, 255)}];
    
    _topDaySectionOpen = YES;
    _topWeekSectionOpen = YES;
    _topMonthSectionOpen = YES;
    
    [self isOnline];
    self.navigationController.navigationBar.barTintColor = COLORWITHRGB(240, 95, 102);
    
}

- (void)isOnline
{
    _reachableManager = [Reachability reachabilityWithHostName:@"bbs.wfun.com"];
    switch (_reachableManager.currentReachabilityStatus) {
        case ReachableViaWiFi:
            [self loadFromLocal];
            
            [self loadData];
            break;
        case ReachableViaWWAN:
            [self loadFromLocal];
            [self loadData];
            break;
        case NotReachable:
            [self loadFromLocal];
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"Network", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles: nil] show];
            break;
            
        default:
            break;
    }
}

- (void)loadFromLocal
{
    NSData * localData = [[NSUserDefaults standardUserDefaults] objectForKey:@"local"];
    
    [_topNewsArr removeAllObjects];
    [_topNewsArr addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:localData]];
    
    [self.newsListView reloadData];
    //NSLog(@"load success!");
}

- (void)saveToLocal
{
    
    NSData * localData = [NSKeyedArchiver archivedDataWithRootObject:_topNewsArr];
    [[NSUserDefaults standardUserDefaults] setObject:localData forKey:@"local"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"save success!");
}

- (void)loadData
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _requestManager = [AFHTTPRequestOperationManager manager];
    _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_requestManager GET:HOT_NEWS_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_topNewsArr removeAllObjects];
        
        NSDictionary * rootDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * topDayArr = rootDict[@"top_day"];
        NSMutableArray * topDayMutArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary * dict in topDayArr) {
            if (![dict isKindOfClass:[NSNull class]]) {
                NewsModel * model = [[NewsModel alloc] initWithDict:dict];
                [topDayMutArr addObject:model];
            }
        }
        [_topNewsArr addObject:topDayMutArr];
        
        NSArray * topWeekArr = rootDict[@"top_week"];
        NSMutableArray * topWeekMutArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary * dict in topWeekArr) {
            if (![dict isKindOfClass:[NSNull class]]) {
                NewsModel * model = [[NewsModel alloc] initWithDict:dict];
                [topWeekMutArr addObject:model];
            }
        }
        [_topNewsArr addObject:topWeekMutArr];
        
        NSArray * topMonthArr = rootDict[@"top_moon"];
        NSMutableArray * topMonthMutArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary * dict in topMonthArr) {
            if (![dict isKindOfClass:[NSNull class]]) {
                NewsModel * model = [[NewsModel alloc] initWithDict:dict];
                [topMonthMutArr addObject:model];
            }
        }
        [_topNewsArr addObject:topMonthMutArr];
        [self.newsListView reloadData];
        [self saveToLocal];
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _topNewsArr.count > 0 ? _topNewsArr.count : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if (_topDaySectionOpen) {
                return [_topNewsArr[section] count];
            } else {
                return 0;
            }
            break;
        case 1:
            if (_topWeekSectionOpen) {
                return [_topNewsArr[section] count];
            } else {
                return 0;
            }
            break;
        case 2:
            if (_topMonthSectionOpen) {
                return [_topNewsArr[section] count];
            } else {
                return 0;
            }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    NewsModel * model = _topNewsArr[indexPath.section][indexPath.row];
    
    [cell.newsPic sd_setImageWithURL:[NSURL URLWithString:model.newsPicUrl] placeholderImage:[UIImage imageNamed:@"imgpholder"]];
    cell.newsTitle.text = model.newsTitle;
    cell.newsInfo.text = [NSString stringWithFormat:@"分类:%@ | 热度:%ld/%ld | %@", model.newsClassName, model.newsReplies.integerValue, model.newsViewers.integerValue, model.newsDateLine];
    
    if (model.newsRecommend.integerValue != 0) {
        
        HexFromString * hex = [[HexFromString alloc] init];
        
        NSArray * colorValueArr = [hex RGBWithHexString:model.newsHighLight];
        
        NSInteger redValue = [colorValueArr[0] integerValue];
        NSInteger blueValue = [colorValueArr[2] integerValue];
        NSInteger greenValue = [colorValueArr[1] integerValue];
        
        cell.newsTitle.textColor = COLORWITHRGB(redValue, greenValue, blueValue);
    } else {
        cell.newsTitle.textColor = [UIColor blackColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.newsSummary.text = model.newsSummary;
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerTitleLabel.backgroundColor = COLORWITHRGB(147, 224, 255);
    headerTitleLabel.font = [UIFont systemFontOfSize:18];
    headerTitleLabel.userInteractionEnabled = YES;
    headerTitleLabel.tag = 100 + section;
    
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSection:)];
    [headerTitleLabel addGestureRecognizer:tapGR];
    
    switch (section) {
        case 0:
            headerTitleLabel.text = NSLocalizedString(@"TopToday", nil);
            break;
        case 1:
            headerTitleLabel.text = NSLocalizedString(@"TopWeek", nil);
            break;
        case 2:
            headerTitleLabel.text = NSLocalizedString(@"TopMonth", nil);
            break;
            
        default:
            break;
    }
    headerTitleLabel.textColor = COLORWITHRGB(255, 66, 93);
    return headerTitleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NewsDetailViewController * ndvc = [[NewsDetailViewController alloc] init];
    NewsModel * model = [_topNewsArr[indexPath.section] objectAtIndex:indexPath.row];
    NewsContentViewController * ncvc = [[NewsContentViewController alloc] initWithUrl:model.newsAPIUrl];
    
//    ndvc.model = model;    
//    ndvc.newsTitleString = model.newsTitle;
//    
//    NSDate * newsDate = [NSDate dateWithTimeIntervalSince1970:[model.newsDBDateLine floatValue]];
//    
//    NSDateFormatter * df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
//    
//    ndvc.newsInfoString = [NSString stringWithFormat:@"%@ | %@", [df stringFromDate:newsDate], model.newsAuthorName];
//    
//    
//    ndvc.hidesBottomBarWhenPushed = YES;
//    ndvc.webUrl = model.newsAPIUrl;
//    [self.navigationController pushViewController:ndvc animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:ncvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ncvc.hidesBottomBarWhenPushed = YES;
}

#pragma mark -点击分组头视图响应事件
- (void)tapSection:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag - 100) {
        case 0:
            _topDaySectionOpen = !_topDaySectionOpen;
            break;
        case 1:
            _topWeekSectionOpen = !_topWeekSectionOpen;
            break;
        case 2:
            _topMonthSectionOpen = !_topMonthSectionOpen;
            break;
        default:
            break;
    }
    [self.newsListView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag - 100] withRowAnimation:UITableViewRowAnimationFade];
}
@end
