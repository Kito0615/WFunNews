//
//  CommentController.m
//  WPXap
//
//  Created by AnarL on 15/9/29.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

#import "CommentController.h"
#import "CommentModel.h"
#import "MJRefresh.h"

@interface CommentController ()

@end

@implementation CommentController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _currentCommentPage = 1;
    
    self.navigationController.navigationBar.tintColor = COLORWITHRGB(255, 255, 255);
    
    [self reachAbilityTest];
    
    // 添加监听键盘呼出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 添加监听键盘收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.title = NSLocalizedString(@"Title", nil);
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:COLORWITHRGB(255, 255, 255)};
    
    self.navigationController.navigationBar.barTintColor = COLORWITHRGB(240, 95, 102);
    
    _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sortBtn.frame = CGRectMake(0, 0, 30 , 20);
    _sortBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_sortBtn setTitle:NSLocalizedString(@"Ordered", nil) forState:UIControlStateSelected];
    [_sortBtn setTitle:NSLocalizedString(@"Latest", nil) forState:UIControlStateNormal];
    _sortBtn.selected = NO;
    [_sortBtn addTarget:self action:@selector(sortCommentArr:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sortBtn];
    
    
    self.commentField.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCellTypeOne" bundle:nil] forCellReuseIdentifier:@"cellTypeOne"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCellTypeTwo" bundle:nil] forCellReuseIdentifier:@"cellTypeTwo"];
    
    [self pullToRefresh];
    [self pullToLoadMore];
    
}

- (void)sortCommentArr:(UIButton *)sortBtn
{
    sortBtn.selected = !sortBtn.selected;
    
    [self.tableView reloadData];
}

#pragma mark -检查网络连接状况
- (void)reachAbilityTest
{
    _networkTest = [Reachability reachabilityWithHostName:@"bbs.wfun.com"];
    
    
    switch (_networkTest.currentReachabilityStatus) {
        case ReachableViaWiFi:
            
            [self getAllComment];
            
            break;
        case ReachableViaWWAN:
            
            [self getAllComment];
            
            break;
        case NotReachable:
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"Network", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles: nil] show];
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark -从网络获取评论数据
- (void)getAllComment
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _commentArr = [[NSMutableArray alloc] init];

    _requestManager = [AFHTTPRequestOperationManager manager];
    _requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * url = [NSString stringWithFormat:@"%@&page=%ld&app=anar0615", self.commentUrl, _currentCommentPage];
    NSLog(@"%@", url);
    
    [_requestManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSArray * commentArr = dict[@"comment"];
        
        if (dict[@"comment"] == [NSNull null]) {
            
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"NoComment", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles:nil] show];
            
            [hud hide:YES];
            
            return ;
        }
        
        
        if (commentArr.count > 0) {
            for (int i = 0; i < commentArr.count; i ++) {
                NSDictionary * comment = commentArr[i];
                CommentModel * model = [[CommentModel alloc] initWithDict:comment];
                [_commentArr addObject:model];
            }
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [hud hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -键盘即将呼出的通知方法
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSTimeInterval keyboardUpTime = [[notification.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    [UIView animateWithDuration:keyboardUpTime animations:^{
        self.bottomSpace.constant = keyboardHeight;
        [self.view layoutIfNeeded];
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


#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArr.count > 0 ? _commentArr.count : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_commentArr.count == 0) {
        
        CommentCellTypeTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cellTypeTwo"];
        
        return cell;
    }
    
    CommentModel *  model = _sortBtn.selected ? [_commentArr objectAtIndex:indexPath.row] :[_commentArr objectAtIndex:_commentArr.count -  indexPath.row - 1];
    
    NSMutableArray * quoteArr = [NSMutableArray arrayWithArray:[model.commentMessage componentsSeparatedByString:@"</q>"]];
    
    if (quoteArr.count != 1) {
        
        for (int i = 0; i < quoteArr.count; i++) {
            // 删除空的字符串
            if ([quoteArr[i] length] == 0) {
                [quoteArr removeObjectAtIndex:i];
                i--;
            }
        }
        NSString * quoteStr = [quoteArr[0] substringFromIndex:3];
        NSString * commentStr = quoteArr[1];
        
        CommentCellTypeTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cellTypeTwo"];
        cell.delegate = self;
        
        cell.quoteComment.text = quoteStr;
        cell.comment.text = commentStr;
        cell.model = model;
        
        cell.commentInfo.text = [NSString stringWithFormat:@"%@ | %@ | %@", model.commentUserName, model.commentDateLine, model.commentLocation];
        
        NSInteger floor = _sortBtn.selected ? _commentArr.count - indexPath.row : indexPath.row + 1;
        
        switch (floor) {
            case 1:
                cell.floorNumber.text = @"沙发";
                break;
            case 2:
                cell.floorNumber.text = @"板凳";
                break;
            case 3:
                cell.floorNumber.text = @"地板";
                break;
                
            default:
                cell.floorNumber.text = [NSString stringWithFormat:@"%ld楼", floor];
                break;
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    } else {
    
        CommentCellTypeOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cellTypeOne"];
        cell.delegate = self;
        cell.commentInfo.text = [NSString stringWithFormat:@"%@ | %@ | %@", model.commentUserName, model.commentDateLine, model.commentLocation];
        cell.commentContent.text = model.commentMessage;
        cell.model = model;

        NSInteger floor = _sortBtn.selected ? _commentArr.count - indexPath.row : indexPath.row + 1;
        
        switch (floor) {
            case 1:
                cell.floorNumber.text = @"沙发";
                break;
            case 2:
                cell.floorNumber.text = @"板凳";
                break;
            case 3:
                cell.floorNumber.text = @"地板";
                break;
                
            default:
                cell.floorNumber.text = [NSString stringWithFormat:@"%ld楼", floor];
                break;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_commentArr.count == 0) {
        return 0;
    }
    NSInteger index = _sortBtn.selected ? indexPath.row : _commentArr.count -  indexPath.row - 1;
    
    CommentModel * model = _commentArr[index];
    
    NSMutableArray * isQuoteArr = [NSMutableArray arrayWithArray:[model.commentMessage componentsSeparatedByString:@"</q>"]];
    
    if (isQuoteArr.count != 1) {
        
        for (int i = 0; i < isQuoteArr.count; i++) {
            // 删除空的字符串
            if ([isQuoteArr[i] length] == 0) {
                [isQuoteArr removeObjectAtIndex:i];
                i--;
            }
        }
        NSString * quoteStr = [isQuoteArr[0] substringFromIndex:3];
        NSString * commentStr = isQuoteArr[1];
        
        CGSize quoteSize = [quoteStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 120, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        CGSize commentSize = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 75, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        return 70 + quoteSize.height + commentSize.height;
        
    } else {
        
        NSString * commentStr = model.commentMessage;
        CGSize stringSize = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 75, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        
        return stringSize.height + 70;
    }
}

#pragma mark -ReplyCommentDelegate
- (void)replyCommentTo:(NSNumber *)pid
{
    [self.commentField becomeFirstResponder];
    self.commentField.placeholder = NSLocalizedString(@"Reply", nil);
    self.commentPid = pid;
}

#pragma mark -点赞按钮点击事件
- (void)agreeWith:(NSNumber *)pid
{
    
}

#pragma mark -反对按钮点击事件
- (void)disagreeWith:(NSNumber *)pid
{
}



#pragma mark -提交按钮
- (IBAction)submitBtn:(UIButton *)sender {
    
    if (self.commentField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"EnterComment", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles:nil] show];
        return;
    }
    
    
    NSString * postUrlStr = [NSString stringWithFormat:@"http://api.wpxap.com/Send?tid=%ld&app=anar0615", self.newsId.integerValue];
    NSString * tokenStr = [NSString stringWithFormat:@"%ld|%ld|1173785|%@|cappuccino", self.newsId.integerValue, self.commentPid.integerValue, [UIDevice currentDevice].name];
    NSLog(@"%@", [UIDevice currentDevice].name);
    NSLog(@"%ld", self.commentPid.integerValue);
    NSString * encodedToken = [Base64Encryption base64StringFromText:tokenStr];
    
    NSDictionary * postDict = @{@"token":encodedToken, @"message":self.commentField.text, @"devicename":[UIDevice currentDevice].name};
    
    
    [_requestManager POST:postUrlStr parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * retDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (retDict[@"pid"]) {
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"Submit", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            
            [self performSelector:@selector(cancelAlertView:) withObject:alert afterDelay:1];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"%@", error.localizedFailureReason);
    }];
    [self.commentField resignFirstResponder];
    self.commentField.text = @"";
    self.commentField.placeholder = NSLocalizedString(@"Comment", nil);
    [self getAllComment];
}

- (void)cancelAlertView:(UIAlertView *)alert
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -下拉刷新评论列表
- (void)pullToRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        _currentCommentPage = 1;
        
        [_commentArr removeAllObjects];
        [self getAllComment];
        
    }];

}

#pragma mark -上拉加载更多评论
- (void)pullToLoadMore
{
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (_commentArr.count < 50) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"NoMore", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Confirm", nil) otherButtonTitles:nil];
            [alertView show];

            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            return;
            
        }
        _currentCommentPage ++;
        [self getAllComment];
        
    }];
}
#pragma mark -UITableViewDelegate（取消cell的选中状态）
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}


@end
