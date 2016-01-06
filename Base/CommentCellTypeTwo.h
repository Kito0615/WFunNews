//
//  CommentCellTypeTwo.h
//  WPXap
//
//  Created by AnarL on 15/9/29.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@protocol ReplyCommentDelegate <NSObject>
/**
 *  回复评论协议代理方法
 *
 *  @param pid 要回复的评论id
 */
- (void)replyCommentTo:(NSNumber *)pid;

/**
 *  点赞评论协议代理方法
 *
 *  @param pid 要点赞的评论id
 */
- (void)agreeWith:(NSNumber *)pid;

/**
 *  反对评论协议代理方法
 *
 *  @param pid 要反对的评论id
 */
- (void)disagreeWith:(NSNumber *)pid;

@end

@interface CommentCellTypeTwo : UITableViewCell
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
/**
 *  评论相关信息标签
 */
@property (weak, nonatomic) IBOutlet UILabel *commentInfo;
/**
 *  评论楼层标签
 */
@property (weak, nonatomic) IBOutlet UILabel *floorNumber;
/**
 *  回复评论点击事件
 */
- (IBAction)replyComment:(UIButton *)sender;
/**
 *  点赞评论点击事件
 */
- (IBAction)supportComment:(UIButton *)sender;
/**
 *  反对评论点击事件
 */
- (IBAction)disagreeComment:(UIButton *)sender;
/**
 *  评论中被引用的评论标签
 */
@property (weak, nonatomic) IBOutlet UILabel *quoteComment;
/**
 *  评论标签
 */
@property (weak, nonatomic) IBOutlet UILabel *comment;

/**
 *  评论数据模型
 */
@property (nonatomic, strong) CommentModel * model;

/**
 *  评论协议代理 
 */
@property (nonatomic, assign) id <ReplyCommentDelegate> delegate;

@end
