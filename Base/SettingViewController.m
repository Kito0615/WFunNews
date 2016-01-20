//
//  SettingViewController.m
//  WFunNews
//
//  Created by AnarL on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define WEATHER_REQUST_URL_BY_CITYNAM @"http://apis.baidu.com/apistore/weatherservice/cityname"
#define WEATHER_REQUEST_URL_BY_POINT @"http://apis.baidu.com/showapi_open_bus/weather_showapi/point"


#define WEATHER_ARGUMENTS @"lng=%f&lat=%f&from=5&needMoreDay=0&needIndex=0"
#define BAIDU_APPKEY @"4927e824fdb6fd14d62dbfc3a7b5472b"

#import "UIImageView+WebCache.h"

#import "SettingViewController.h"

@interface SettingViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager * _locationManager;
    CLLocation * _currentLocation;
    
    CLGeocoder * _geoCoder;
}


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务没有打开，请打开设置");
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        [_locationManager startUpdatingLocation];
    }
    
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
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Feedback", nil) message:[NSString stringWithFormat:@"Version:%@\n%@",[NSString stringWithFormat:@"%@(%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]], NSLocalizedString(@"Mail", nil)] delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles: nil] show];
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
 *  查询逆地理编码
 */
- (void)reGeoCode
{
    _geoCoder = [[CLGeocoder alloc] init];
    
    [_geoCoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark * placeMark = [placemarks firstObject];
        
        CLLocation * location = placeMark.location;
        CLRegion * region = placeMark.region;
        
        NSDictionary * addressDict = placeMark.addressDictionary;
        
        NSLog(@"==========位置：%@\n=========区域：%@\n=======详细：%@===========", location, region, addressDict);
        
        self.location.text = [NSString stringWithFormat:@"%@%@%@", addressDict[@"State"], addressDict[@"City"], addressDict[@"SubLocality"]];
        
    }];
    
}

#pragma mark -CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = [locations firstObject];
    _currentLocation = location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度：%f\n纬度：%f", coordinate.longitude, coordinate.latitude);
    NSLog(@"海拔：%f\n方向：%f\n速度：%f", location.altitude, location.course, location.speed);
    
    [self loadWeatherWithUserLocation:location];
    [self reGeoCode];
    
}

#pragma mark -获取当前用户所在地的天气状况

- (void)loadWeatherWithUserLocation:(CLLocation *)location
{
    NSString * requestArg = [NSString stringWithFormat:WEATHER_ARGUMENTS, location.coordinate.longitude, location.coordinate.latitude];
    
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
