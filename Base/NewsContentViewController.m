//
//  NewsContentViewController.m
//  WFunNews
//
//  Created by AnarL on 16/5/10.
//  Copyright © 2016年 AnarL. All rights reserved.
//
#define IMAGE_REGEX @"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?.(png|jpg)"
#define SUPER_LINK_REGEX @"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?"
#define VIDEO_LINK_REGEX @"(http|https):\\/\\/v.youku.com\\/v_show\\/id_(\\w*)==\\.html"
#define SUPER_LINK_WORD_REGEX @"(>)\\w*(</a>)"

#define SUBMIT_COMMENT_URL @"http://api.wpxap.com/Send?tid=%ld&app=anar0615"

#import "NewsContentViewController.h"
#import "UMSocial.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NSString+EditString.h"
#import "ImageDetailViewController.h"
#import "CommentController.h"

@interface NewsContentViewController ()<UITextFieldDelegate, UMSocialUIDelegate>
{
    NSMutableArray * _imageUrls;
    NSMutableArray * _videoUrls;
    
    AFHTTPSessionManager * _manager;
    NSInteger _newsID;
    NSString * _newsUrl;
    
    UIButton * _playButton;
    
    UIScrollView * _contentScrollView;
    
    UILabel * _titleLabel;
    UILabel * _newsInfoLabel;
    UILabel * _contentLabel;
    
    UIImageView * _contentImageView;
    
    UIView * _commentView;
    UITextField * _commentField;
    UIButton * _submitButton;
    
    ImageDetailViewController * _imageDetailVC;
    
    NSString * _commentUrl;
}

@end

@implementation NewsContentViewController

- (instancetype)initWithUrl:(NSString *)newsContentUrl
{
    if (self = [super init]) {
        [self loadPageWithUrl:newsContentUrl];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(240 / 255.0) green:(97 / 255.0) blue:(102 / 255.0) alpha:1.00];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:(240 / 255.0) green:(97 / 255.0) blue:(102 / 255.0) alpha:1.00];
    
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:(240 / 255.0) green:(97 / 255.0) blue:(102 / 255.0) alpha:1.00]];
    
//    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -69, [UIScreen mainScreen].bounds.size.width, 69)];
//    bgView.backgroundColor = [UIColor colorWithRed:(31 / 255.0) green:(30 / 255.0) blue:(31 / 255.0) alpha:1.00];
//    [self.view addSubview:bgView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)loadPageWithUrl:(NSString *)url
{
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [_manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSDictionary * detailInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            _newsID = [[detailInfo objectForKey:@"id"] integerValue];
            _newsUrl = [detailInfo objectForKey:@"weburl"];
            _commentUrl = [detailInfo objectForKey:@"comment_url"];
            
            [self setupPageWithDict:detailInfo];
            NSString * contentString = [NSString insertString:@"\r\n" intoString:detailInfo[@"message"] afterSubString:@"via:"];
            
            [self fetchAllImageUrls:contentString];
            [self fetchAllVideoUrls:contentString];
            
            [self setupPage:contentString];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)setupPageWithDict:(NSDictionary *)dict
{
    [self setupTitle:dict[@"title"]];
    NSString * infoString = [NSString stringWithFormat:@"%@ | %@\t", dict[@"uname"], dict[@"dateline"]];
    [self setupPageInfo:infoString];
}


- (void)setupTitle:(NSString *)title
{
    self.title = NSLocalizedString(@"Content", nil);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width, 45)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor redColor];
    _titleLabel.alpha = 0.75;
    _titleLabel.text = title;
    
    [_contentScrollView addSubview:_titleLabel];
}

- (void)setupPageInfo:(NSString *)pageInfo
{
    _newsInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width, 25)];
    _newsInfoLabel.text = pageInfo;
    _newsInfoLabel.textAlignment = NSTextAlignmentRight;
    _newsInfoLabel.textColor = [UIColor lightGrayColor];
    _newsInfoLabel.font = [UIFont systemFontOfSize:13];
    _newsInfoLabel.alpha = 0.8;
    
    [_contentScrollView addSubview:_newsInfoLabel];
}

- (void)setupPage:(NSString *)content
{
    NSArray * _contentArray = [self analysePageContent:content];
    
    CGFloat componentWidth = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat maxComponentHeight = 1000;
    
    CGFloat lastH = 0;
    CGFloat lastY = 80;
    int imageIndex = 0;
    int videoIndex = 0;
    
    for (int i = 0; i < _contentArray.count; i ++) {
        CGFloat componentX = 5;
        CGFloat componentY = lastY + lastH + 5;
        
        CGFloat labelHeight;
        CGFloat imageHeight = componentWidth * 9.0 / 16.0;
        
        NSRange imageRange = [_contentArray[i] rangeOfString:@"img src"];
        
        if (imageRange.location == NSNotFound) {
            NSString * paragraphString = [NSString stringWithFormat:@"    %@", _contentArray[i]];
            NSString * superlink = [self analyseParagraph:paragraphString];
            
            labelHeight = [superlink boundingRectWithSize:CGSizeMake(componentWidth, maxComponentHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
            
            if ([superlink rangeOfString:@"via:"].location != NSNotFound) {
                _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(componentX, componentY, componentWidth, labelHeight)];
                _contentLabel.userInteractionEnabled = YES;
                NSMutableAttributedString * link = [[NSMutableAttributedString alloc] initWithString:superlink];
                [link addAttribute:NSLinkAttributeName value:link range:NSMakeRange(0, link.length)];
                UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink:)];
                [_contentLabel addGestureRecognizer:tapGR];
                _contentLabel.numberOfLines = 0;
                _contentLabel.font = [UIFont systemFontOfSize:16];
                _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
                [_contentScrollView addSubview:_contentLabel];
            } else {
                _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(componentX, componentY, componentWidth, labelHeight)];
                _contentLabel.text = superlink;
                _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
                _contentLabel.numberOfLines = 0;
                _contentLabel.font = [UIFont systemFontOfSize:16];
                [_contentScrollView addSubview:_contentLabel];
            }
            lastH = labelHeight;
        } else {
            _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(componentX, componentY, componentWidth, imageHeight)];
            _contentImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
            [_contentImageView addGestureRecognizer:tapGR];
            
            [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrls[imageIndex]]];
            
            if ([_imageUrls[imageIndex] isEqualToString:@"http://bbs.wfun.com/app_api/img/mov.jpg"]) {
                _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _playButton.frame = CGRectMake((_contentImageView.bounds.size.width - 50) / 2.0, (_contentImageView.bounds.size.height - 50) / 2.0, 50, 50);
                [_playButton.imageView sizeToFit];
                [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
                [_playButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
                
                [_contentImageView addSubview:_playButton];
                [_contentImageView bringSubviewToFront:_playButton];
                
                videoIndex ++;
            }
            
            [_contentScrollView addSubview:_contentImageView];
            lastH = imageHeight;
            imageIndex ++;
        }
        lastY = componentY;
        _contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, lastY + lastH);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49)];
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49 - 64, [UIScreen mainScreen].bounds.size.width, 49)];
    _commentView.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:204 / 255.0 blue:153 / 255.0 alpha:1];
    [self setupCommentView];
    [self setupNavigationBar];
    
    [self.view addSubview:_contentScrollView];
    [self.view addSubview:_commentView];
}

- (void)setupCommentView
{
    _commentField = [[UITextField alloc] initWithFrame:CGRectMake(4.5, 4.5, [UIScreen mainScreen].bounds.size.width - 13.5 - 45, 40)];
    _commentField.delegate = self;
    _commentField.borderStyle = UITextBorderStyleRoundedRect;
    _commentField.returnKeyType = UIReturnKeyDone;
    
    // 监听键盘呼出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowup:) name:UIKeyboardWillShowNotification object:nil];
    
    // 监听键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 49.5, 4.5, 45, 40);
    [_submitButton setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:[UIColor colorWithRed:1 green:153 / 255.0 blue:153 / 255.0 alpha:1]];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _submitButton.layer.cornerRadius = 7;
    _submitButton.layer.masksToBounds = YES;
    [_submitButton addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [_commentView addSubview:_commentField];
    [_commentView addSubview:_submitButton];
}

- (void)setupNavigationBar
{
    UIButton * _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(0, 0, 36, 36);
    [_shareBtn setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareNews:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(0, 0, 36, 36);
    [_commentBtn setImage:[UIImage imageNamed:@"checkComment"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithCustomView:_shareBtn];
    UIBarButtonItem * commentItem = [[UIBarButtonItem alloc] initWithCustomView:_commentBtn];
    
    [self.navigationItem setRightBarButtonItems:@[commentItem, shareItem] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)analysePageContent:(NSString *)content
{
    NSMutableArray * contentParagraph = [NSMutableArray array];
    NSArray * paragraphs = [content componentsSeparatedByString:@"\r\n"];
    NSMutableArray * tempParagraphs = [NSMutableArray arrayWithArray:paragraphs];
    
    for (int i = (int)paragraphs.count - 1; i > -1; i --) {
        if ([paragraphs[i] isEqualToString:@""]) {
            [tempParagraphs removeObjectAtIndex:i];
        }
    }
    [contentParagraph addObjectsFromArray:tempParagraphs];
    
    return contentParagraph;
}

- (NSString *)analyseParagraph:(NSString *)paragraph
{
    NSRegularExpression * superlink = [NSRegularExpression regularExpressionWithPattern:SUPER_LINK_REGEX options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange superlinkParagraph = [paragraph rangeOfString:@"</a>"];
    if (superlinkParagraph.location != NSNotFound) {
        NSTextCheckingResult * result = [[superlink matchesInString:paragraph options:0 range:NSMakeRange(0, paragraph.length)] lastObject];
        
        NSString * superlink = [NSString stringWithFormat:@"    via:%@", [paragraph substringWithRange:result.range]];
        
        return superlink;
    }
    return paragraph;
}

- (void)fetchAllImageUrls:(NSString *)content
{
    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:IMAGE_REGEX options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matchedRanges = [reg matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    _imageUrls = [NSMutableArray array];
    
    for (NSTextCheckingResult * match in matchedRanges) {
        NSRange matchedRange = [match rangeAtIndex:0];
        NSString * matchedString = [content substringWithRange:matchedRange];
        
        [_imageUrls addObject:matchedString];
    }
}

- (void)fetchAllVideoUrls:(NSString *)content
{
    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:VIDEO_LINK_REGEX options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matchedRanges = [reg matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    _videoUrls = [NSMutableArray array];
    
    for (NSTextCheckingResult * match in matchedRanges) {
        NSRange matchedRange = [match rangeAtIndex:0];
        NSString * matchedString = [content substringWithRange:matchedRange];
        
        [_videoUrls addObject:matchedString];
    }
}

#pragma mark -UITapGestureRecognizer
- (void)zoomImage:(UITapGestureRecognizer *)tap
{
    _imageDetailVC = [[ImageDetailViewController alloc] init];
    _imageDetailVC.image = [(UIImageView *)tap.view image];
    [self.navigationController pushViewController:_imageDetailVC animated:YES];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -Target - Actions

- (void)shareNews:(UIButton *)btn
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56dd2bc2e0f55aa563002c55"
                                      shareText:[NSString stringWithFormat:@"%@ %@", _titleLabel.text, _newsUrl]
                                     shareImage:_contentImageView.image
                                shareToSnsNames:@[UMShareToSina, UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatFavorite, UMShareToWechatTimeline]
                                       delegate:self];
}

- (void)openLink:(UITapGestureRecognizer *)tap
{
    UILabel * tapLabel = (UILabel *)tap.view;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tapLabel.text]];
}

- (void)playVideo:(UIButton *)btn
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_videoUrls objectAtIndex:btn.tag - 200]]];
}

- (void)keyboardWillShowup:(NSNotification *)noti
{
    NSTimeInterval keyboardAnimationTime = [[noti.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGFloat keyboardHeight = [[noti.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    [UIView animateWithDuration:keyboardAnimationTime animations:^{
        _commentView.frame = CGRectMake(0, self.view.bounds.size.height - 49 - keyboardHeight, [UIScreen mainScreen].bounds.size.width, 49);
    }];
}

- (void)keyboardWillHidden:(NSNotification *)noti
{
    NSTimeInterval keyboardAnimationTime = [[noti.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:keyboardAnimationTime animations:^{
        _commentView.frame = CGRectMake(0, self.view.bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49);
    }];
}

- (void)showComment:(UIButton *)btn
{
    CommentController * commentVC = [[CommentController alloc] init];
    commentVC.commentUrl = _commentUrl;
    commentVC.newsId = @(_newsID);
    
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

- (void)submitComment:(UIButton *)btn
{
    NSString * _postUrl = [NSString stringWithFormat:SUBMIT_COMMENT_URL, _newsID];
    NSString * _tokenString = [NSString stringWithFormat:@"%ld|%ld|1173785|%@", (long)_newsID, 0l, [[UIDevice currentDevice] name]];
    
    NSString * encodedToken = [Base64Encryption base64StringFromText:_tokenString];
    NSDictionary * postDict = @{@"tokeb" : encodedToken, @"message" : _commentField.text, @"devicename" : [[UIDevice currentDevice] name]};
    
    [_manager POST:_postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (resultDict[@"pid"]) {
            [self showComment:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
