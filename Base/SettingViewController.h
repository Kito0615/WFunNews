//
//  SettingViewController.h
//  WFunNews
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "UMSocial.h"
#import "APService.h"

@interface SettingViewController : UIViewController <MAMapViewDelegate, AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource, UMSocialUIDelegate>
{
    MAMapView * _mapView;
    AMapSearchAPI * _search;
    MAUserLocation * _userLocation;
    NSString * _weatherStatus;
    BOOL _requestSuccess;
    BOOL _isPushOn;
    NSArray * _settingArr;
}
@property (weak, nonatomic) IBOutlet UILabel *location;

@property (weak, nonatomic) IBOutlet UIImageView *weatherPic;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UITableView *settingList;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@end
