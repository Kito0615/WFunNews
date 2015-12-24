//
//  SettingViewController.m
//  WFunNews
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define WEATHER_REQUST_URL_BY_CITYNAM @"http://apis.baidu.com/apistore/weatherservice/cityname"
#define WEATHER_REQUEST_URL_BY_POINT @"http://apis.baidu.com/showapi_open_bus/weather_showapi/point"


#define WEATHER_ARGUMENTS @"lng=%f&lat=%f&from=5&needMoreDay=0&needIndex=0"
#define BAIDU_APPKEY @"4927e824fdb6fd14d62dbfc3a7b5472b"

#import "UIImageView+WebCache.h"

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MAMapServices sharedServices].apiKey = @"847370890d324af7962d4992f11a8b9e";
    _mapView = [[MAMapView alloc] init];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _requestSuccess = NO;
    [self createUI];
    
}

- (void)createUI
{
    self.settingList.delegate = self;
    self.settingList.dataSource = self;
    self.settingList.scrollEnabled = NO;
    _settingArr = @[NSLocalizedString(@"Notification", nil), NSLocalizedString(@"Feedback", nil), NSLocalizedString(@"About", nil), NSLocalizedString(@"Contact", nil), NSLocalizedString(@"Recommend", nil)];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _settingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName = @"settingCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if (indexPath.row == 0) {
        UISwitch * pushSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        pushSwitch.on = _isPushOn;
        [pushSwitch addTarget:self action:@selector(pushOn:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = pushSwitch;
    }
    cell.textLabel.text = _settingArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)pushOn:(UISwitch *)sw
{
    if (sw.on) {
        NSLog(@"开启推送");
    } else {
        NSLog(@"关闭推送");
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_isPushOn ? @"True" : @"False" forKey:@"Push"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _isPushOn = !_isPushOn;
    sw.on = _isPushOn;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Feedback", nil) message:NSLocalizedString(@"Mail", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles: nil] show];
            break;
        case 2:
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"About", nil) message:@"智机网是国内公认最具人气的Windows Phone第一垂直社区，在WP7垂直领域拥有一定的影响力。智机网崇尚“做站就是做人”的社区建设精神，坚持以会员为中心，不断创新，力求发展。" delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles: nil] show];
            
            break;
        case 3:
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Contact", nil) message:NSLocalizedString(@"Mail", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles: nil] show];
            break;
        case 4:
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"5613779167e58e0d200008c7"
                                              shareText:@"智机网iOS客户端，获取最新最快的WP新闻！http://bbs.wfun.com"
                                             shareImage:[UIImage imageNamed:@"Icon"]
                                        shareToSnsNames:@[UMShareToSms,UMShareToEmail]
                                               delegate:self
             ];
            break;
            
        default:
            NSLog(@"%ld", indexPath.row);
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -分享结果
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功:%@", [[response.data allKeys] lastObject]);
    }
}


#pragma mark -隐藏列表多余的行
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

/**
 *  逆地理编码
 */
- (void)reGeoCode
{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    [AMapSearchServices sharedServices].apiKey = @"847370890d324af7962d4992f11a8b9e";
    _search.delegate = self;
    AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc] init];
//    request.searchType = AMapSearchType_ReGeocode;
    request.location = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
    
    [_search AMapReGoecodeSearch:request];
    
}
/**
 *  查询逆地理编码请求
 *
 *  @param request  请求
 *  @param response 响应
 */
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    self.location.text = [NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.province, response.regeocode.addressComponent.city , response.regeocode.addressComponent.district];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.province, response.regeocode.addressComponent.city , response.regeocode.addressComponent.district]);
    
#pragma mark -汉字转拼音
#if 0
    if (self.location.text.length) {
        NSMutableString * ms = [[NSMutableString alloc] initWithString:self.location.text];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)){
            NSLog(@"%@", ms);
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"%@", ms);
        }
        for (int i = 0; i < ms.length; i++) {
            char ch = [ms characterAtIndex:i];
            if (ch == ' ') {
                [ms deleteCharactersInRange:NSMakeRange(i, 1)];
                i -- ;
            }
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"%@", ms);
        }
    }
    if (response.regeocode.addressComponent.city.length == 0) {
        [self loadWeatherWithLocationString:response.regeocode.addressComponent.province];
    } else {
        [self loadWeatherWithLocationString:response.regeocode.addressComponent.city];
    }
#endif
    
}

#pragma mark -是否获取到当前用户的坐标
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //    NSLog(@"latitude: %f, longitude: %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    _userLocation = userLocation;
    
    [self loadWeatherWithLocation:userLocation];
    [self reGeoCode];
}

#pragma mark -获取当前用户所在地的天气状况
- (void)loadWeatherWithLocation:(MAUserLocation *)userlocation
{
    NSString * requestArg = [NSString stringWithFormat:WEATHER_ARGUMENTS, userlocation.coordinate.longitude, userlocation.coordinate.latitude];
    
    [self request:WEATHER_REQUEST_URL_BY_POINT withHttpArg:requestArg];
    
}
/**
 *  请求天气信息
 *
 *  @param httpUrl 请求地址
 *  @param HttpArg 请求参数
 */
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    if (_requestSuccess == NO) {
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        [request setHTTPMethod: @"GET"];
        [request addValue:BAIDU_APPKEY forHTTPHeaderField: @"apikey"];
        [NSURLConnection sendAsynchronousRequest: request
                                           queue: [NSOperationQueue mainQueue]
                               completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   } else {
                                       
                                       NSDictionary * retDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                       NSString * weatherStatus = [[[retDict objectForKey:@"showapi_res_body"] objectForKey:@"f1"] objectForKey:@"day_weather"];
                                       
                                       NSLog(@"%@", weatherStatus);
                                       
                                       NSRange rainRange = [weatherStatus rangeOfString:@"雨"];
                                       NSRange sunnyRange = [weatherStatus rangeOfString:@"晴"];
                                       NSRange cloudyRang = [weatherStatus rangeOfString:@"云"];
                                       NSRange hazeRange = [weatherStatus rangeOfString:@"雾"];
                                       NSRange snowRange = [weatherStatus rangeOfString:@"雪"];
                                       NSRange thickHaze = [weatherStatus rangeOfString:@"霾"];
                                       NSRange cloudy = [weatherStatus rangeOfString:@"阴"];
                                       
                                       
                                       
                                       if (sunnyRange.location != NSNotFound) {
                                           [self.weatherPic setImage:[UIImage imageNamed:@"UseCenterWeatherBGSunny"]];
                                       }  else if (cloudyRang.location != NSNotFound) {
                                           [self.weatherPic setImage:[UIImage imageNamed:@"UseCenterWeatherBGCloudy"]];
                                       } else if (rainRange.location != NSNotFound) {
                                           self.weatherPic.image = [UIImage imageNamed:@"UseCenterWeatherBGRain"];
                                       } else if (snowRange.location != NSNotFound){
                                           self.weatherPic.image = [UIImage imageNamed:@"UseCenterWeatherBGSnow"];
                                       } else if (hazeRange.location != NSNotFound) {
                                           self.weatherPic.image = [UIImage imageNamed:@"UseCenterWeatherBGHaz"];
                                       } else if (thickHaze.location != NSNotFound) {
                                           self.weatherPic.image = [UIImage imageNamed:@"UseCenterWeatherBGHaz"];
                                       } else if (cloudy.location != NSNotFound) {
                                           self.weatherPic.image = [UIImage imageNamed:@"UseCenterWeatherBGCloudy"];
                                       }
                                       [self.weatherIcon sd_setImageWithURL:[NSURL URLWithString:[[[retDict objectForKey:@"showapi_res_body"] objectForKey:@"f1"] objectForKey:@"day_weather_pic"]]];
                                       _requestSuccess = YES;
                                   }
                               }];
    }
}

@end
