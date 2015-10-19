//
//  CommentController.h
//  WPXap
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Base64Encryption.h"
#import "CommentCellTypeOne.h"
#import "CommentCellTypeTwo.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface CommentController : UIViewController <UITableViewDelegate, UITableViewDataSource, ReplyCommentDelegate, UITextFieldDelegate>
{
    NSMutableArray * _commentArr;
    NSMutableArray * _hotCommentArr;
    AFHTTPRequestOperationManager * _requestManager;
    NSInteger _currentCommentPage;
    Reachability * _networkTest;
    
    UIButton * _sortBtn;
}
@property (nonatomic, assign) BOOL isDay;
@property (nonatomic, copy) NSString * commentUrl;
@property (nonatomic, strong) NSNumber * newsId;
@property (nonatomic, strong) NSNumber * commentPid;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *commentArea;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
- (IBAction)submitBtn:(UIButton *)sender;

@end
