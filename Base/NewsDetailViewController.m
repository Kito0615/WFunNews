//
//  NewsDetailViewController.m
//  WFunNews
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SUBMIT_COMMENT_URL @"http://api.wpxap.com/Send?tid=%ld&app=anar0615"
#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

#import "NewsDetailViewController.h"
#import "CommentController.h"
#import "SharePlate.h"

@interface NewsDetailViewController () <SharePlateProtocal>
{
    SharePlate * _sharePlate;
    UIView * _shadowView;
    
    BOOL _shareBtnClicked;
    
}

@end

@implementation NewsDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.tintColor = COLORWITHRGB(255, 255, 255);
    
    _oldTitleFrame = self.newsTitleLabel.frame;
    _oldInfoFrame = self.newsInfoLabel.frame;
    
    self.title = @"新闻详情";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:COLORWITHRGB(255, 255, 255)};
    self.navigationController.navigationBar.barTintColor = COLORWITHRGB(240, 95, 102);
    [self createNavigationBarButtons];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加监听键盘呼出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 添加监听键盘收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.newsContentView.delegate = self;
    [self isOnline];
}

- (void)isOnline
{
    _reachableManager = [Reachability reachabilityWithHostName:@"bbs.wfun.com"];
    switch (_reachableManager.currentReachabilityStatus) {
        case ReachableViaWiFi:
            [self loadNewsContent];
            break;
        case ReachableViaWWAN:
            [self loadNewsContent];
            break;
        case NotReachable:
            break;
            
        default:
            break;
    }
}

- (void)loadNewsContent
{
    _requestManager = [AFHTTPRequestOperationManager manager];
    _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.newsTitleLabel.text = self.newsTitleString;
    self.newsInfoLabel.text = self.newsInfoString;
    
    [_requestManager GET:self.webUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * newsContentDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString * html_header = [NSString stringWithFormat:@"<head><style type=\"text/css\">img{width:%fpx !important;}\n\rbody{background-color:transparent;font-size:12pt;line-height:18pt;width:%fpx;margin-left:10px;margin-top:10px;text-indent:12pt}\n\r</style></head>", SCREEN_WIDTH - 20, SCREEN_WIDTH - 20];
        NSString * sourceString = [NSString stringWithFormat:@"%@%@", html_header, newsContentDict[@"message"]];
        
        _webString = [self insertBreakLineSymbolBeforeImageWithHtmlString:sourceString];
        
        self.newsCommentUrl = newsContentDict[@"comment_url"];
        self.newsId = newsContentDict[@"tid"];
        
        [self.newsContentView loadHTMLString:_webString baseURL:nil];
        self.newsContentView.scrollView.showsVerticalScrollIndicator = NO;
        [self.newsContentView setDataDetectorTypes:UIDataDetectorTypeAll];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSString *)insertBreakLineSymbolBeforeImageWithHtmlString:(NSString *)htmlString
{
    NSMutableString * sourceStr = [[NSMutableString alloc] initWithString:htmlString];
    
    NSRange subStringRange = [sourceStr rangeOfString:@"<img" options:NSBackwardsSearch range:NSMakeRange(0, sourceStr.length)];
    
    while (subStringRange.location != NSNotFound) {
        
        NSRange lastRange = NSMakeRange(subStringRange.location, subStringRange.length);
        
        NSLog(@"%@", NSStringFromRange(subStringRange));
        
        [sourceStr insertString:@"<br>" atIndex:lastRange.location];
        
        subStringRange = [sourceStr rangeOfString:@"<img" options:NSBackwardsSearch range:NSMakeRange(0, lastRange.location)];
    }
    
    subStringRange = [sourceStr rangeOfString:@"/>" options:NSBackwardsSearch range:NSMakeRange(0, sourceStr.length)];
    
    while (subStringRange.location != NSNotFound) {
        NSRange lastRange = NSMakeRange(subStringRange.location, subStringRange.length);
        NSLog(@"%@", NSStringFromRange(lastRange));
        
        [sourceStr insertString:@"<br>" atIndex:lastRange.location + lastRange.length];
        
        subStringRange = [sourceStr rangeOfString:@"/>" options:NSBackwardsSearch range:NSMakeRange(0, lastRange.location)];
    }
    return sourceStr;
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//     [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#ACACAC'"];
}



- (void)createNavigationBarButtons
{
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(4, 0, 22, 22);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(34, 0, 22, 22);
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"checkComment"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    
    [buttonsView addSubview:shareBtn];
    [buttonsView addSubview:commentBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonsView];
    
}

#pragma mark -分享按钮
- (void)shareButtonClicked
{
    NSLog(@"分享");
    
    /**
     *  设置各个平台扩展内容
     */
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"";
#if 1
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5613779167e58e0d200008c7"
                                      shareText:[NSString stringWithFormat:@"%@%@", self.model.newsTitle, self.model.newsWebUrl]
                                     shareImage:self.newsImage
                                shareToSnsNames:@[UMShareToSina, UMShareToQQ, UMShareToQzone, UMShareToRenren,UMShareToTencent, UMShareToWechatTimeline, UMShareToLWSession, UMShareToWechatFavorite]
                                       delegate:self];
#endif
    
#if 0
    
    /**
     *  自定义分享样式
     */
    
    if (!_shareBtnClicked) {
        
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        _sharePlate = [SharePlate sharePlate];
        
        _sharePlate.frame = CGRectMake(0, _shadowView.bounds.size.height, SCREEN_WIDTH, 250);
        _sharePlate.delegate = self;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _sharePlate.frame = CGRectMake(0, _shadowView.bounds.size.height - 250, SCREEN_WIDTH, 250);
            _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            
        }];
        _shareBtnClicked = YES;
    }
    
    
    
    [_shadowView addSubview:_sharePlate];
    [self.view addSubview:_shadowView];
    
#endif
}

#pragma mark -SharePlateProtocal

- (void)cancelBtnClicked
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _sharePlate.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
    } completion:^(BOOL finished) {
        [_sharePlate removeFromSuperview];
        [_shadowView removeFromSuperview];
        _shadowView = nil;
        _sharePlate = nil;
        _shareBtnClicked = NO;
    }];
}

- (void)shareToSinaBtnClicked
{
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@", self.model.newsTitle, self.model.newsWebUrl] image:self.newsImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
            
            NSLog(@"成功分享到:%@",[[response.data allKeys] lastObject]);
        }
    }];
}

- (void)shareToTencentBtnClicked
{
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToTencent] content:[NSString stringWithFormat:@"%@%@", self.model.newsTitle, self.model.newsWebUrl] image:self.newsImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
            NSLog(@"成功分享到:%@",[[response.data allKeys] lastObject]);
        }
    }];

}

- (void)shareToRenRenBtnClicked
{
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToRenren] content:[NSString stringWithFormat:@"%@%@", self.model.newsTitle, self.model.newsWebUrl] image:self.newsImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        
        [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"成功分享到:%@",[[response.data allKeys] lastObject]);
        }
    }];

}

- (void)shareToQzoneBtnClicked
{
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"%@%@", self.model.newsTitle, self.model.newsWebUrl] image:self.newsImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
            
            NSLog(@"成功分享到:%@",[[response.data allKeys] lastObject]);
        }
    }];

}

- (void)shareToWechatBtnClicked
{
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@%@", self.model.newsTitle, self.model.newsWebUrl] image:self.newsImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
            
            NSLog(@"成功分享到:%@",[[response.data allKeys] lastObject]);
        }
    }];

}

- (void)shareToWechatTimelineBtnClicked
{
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@%@", self.model.newsTitle, self.model.newsWebUrl] image:self.newsImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
            
            NSLog(@"成功分享到:%@",[[response.data allKeys] lastObject]);
        }
    }];

}









#pragma mark -UMSocialUIDelegate
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功:%@", [[response.data allKeys] lastObject]);
    }
}

#pragma mark -查看评论按钮
- (void)commentButtonClicked
{
    NSLog(@"评论");
    
    CommentController * commentVC = [[CommentController alloc] init];
    commentVC.commentUrl = self.newsCommentUrl;
    commentVC.newsId = self.newsId;
    
    [self.navigationController pushViewController:commentVC animated:YES];
    
    
}



#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.newsContentView.scrollView) {
        
        self.newsTitleLabel.frame = CGRectMake(_oldTitleFrame.origin.x, _oldTitleFrame.origin.y - scrollView.contentOffset.y, _oldTitleFrame.size.width, _oldTitleFrame.size.height);
        self.newsInfoLabel.frame = CGRectMake(_oldInfoFrame.origin.x, _oldInfoFrame.origin.y - scrollView.contentOffset.y, _oldInfoFrame.size.width, _oldInfoFrame.size.height);
        _newsContentOffset = scrollView.contentOffset;
    }
}

#pragma mark -键盘即将呼出的通知方法
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSTimeInterval keyboardUpTime = [[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    [UIView animateWithDuration:keyboardUpTime animations:^{
        self.bottomSpace.constant = keyboardHeight;
        
    }];
}

#pragma mark -键盘即将消失的通知方法
- (void)keyboardWillHidden:(NSNotification *)notification
{
    NSTimeInterval keyboardDownTime = [[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:keyboardDownTime animations:^{
        self.bottomSpace.constant = 0;
        [self.view layoutIfNeeded];

    }];
    
}




- (IBAction)submitCommentBtn:(UIButton *)sender {
    
    if (self.commentField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，说点什么吧…" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    NSString * postUrlStr = [NSString stringWithFormat:SUBMIT_COMMENT_URL, self.newsId.integerValue];
    NSString * tokenStr = [NSString stringWithFormat:@"%ld|0|1173785|%@|cappuccino", self.newsId.integerValue, [UIDevice currentDevice].name];
    NSString * encodedTokenStr = [Base64Encryption base64StringFromText:tokenStr];
    
    NSDictionary * postDict = @{@"token":encodedTokenStr, @"message":self.commentField.text, @"devicename":[UIDevice currentDevice].name};
    
    [_requestManager POST:postUrlStr parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * retDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (retDict[@"pid"]) {
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"提交评论成功！跳转评论页…" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
            
        }
        
        NSLog(@"%@", retDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        NSLog(@"%@", error.localizedFailureReason);
        
    }];
    
    [self.commentField resignFirstResponder];
    self.commentField.text = @"";
    
    [self commentButtonClicked];
    
}

- (void)cancelAlertView:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

@end