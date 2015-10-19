//
//  NewsDetailViewController.h
//  WFunNews
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Base64Encryption.h"
#import "Reachability.h"
#import "NewsModel.h"
#import "UMSocial.h"

@interface NewsDetailViewController : UIViewController<UIScrollViewDelegate, UMSocialUIDelegate, UIWebViewDelegate>
{
    AFHTTPRequestOperationManager * _requestManager;
    Reachability * _reachableManager;
    NSString * _webString;
    
    
    CGRect _oldTitleFrame;
    CGRect _oldInfoFrame;
    CGPoint _newsContentOffset;
}

@property (nonatomic, strong) NewsModel * model;

@property (nonatomic, strong) NSNumber * newsId;
@property (nonatomic, strong) NSNumber * replyId;
@property (nonatomic, copy) NSString * newsTitleString;
@property (nonatomic, copy) NSString * newsInfoString;
@property (nonatomic, copy) NSString * webUrl;
@property (nonatomic, copy) NSString * newsCommentUrl;
@property (nonatomic, assign) UIImage * newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsInfoLabel;
@property (weak, nonatomic) IBOutlet UIWebView *newsContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
- (IBAction)submitCommentBtn:(UIButton *)sender;




@end
