//
//  CommentCellTypeOne.h
//  WPXap
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "CommentCellTypeTwo.h"

@interface CommentCellTypeOne : UITableViewCell
/**
 *  评论点赞按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
/**
 *  评论反对按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;
/**
 *  评论用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
/**
 *  评论相关信息标签
 */
@property (weak, nonatomic) IBOutlet UILabel *commentInfo;
/**
 *  评论楼层信息标签
 */
@property (weak, nonatomic) IBOutlet UILabel *floorNumber;
/**
 *  评论内容
 */
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
/**
 *  回复评论按钮点击事件
 */
- (IBAction)replyComment:(UIButton *)sender;
/**
 *  评论点赞按钮点击事件
 */
- (IBAction)supportComment:(UIButton *)sender;
/**
 *  评论反对按钮点击事件
 */
- (IBAction)disgreeComment:(UIButton *)sender;

/**
 *  评论数据模型
 */
@property (nonatomic, strong) CommentModel * model;
/**
 *  回复评论代理
 */
@property (nonatomic, assign) id<ReplyCommentDelegate> delegate;

@end
