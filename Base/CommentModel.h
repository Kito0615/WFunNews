//
//  CommentModel.h
//  WPXap
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/**
 *  评论时间（格式化）
 */
@property (nonatomic, copy) NSString * commentDateLine;
/**
 *  评论时间（未格式化）
 */
@property (nonatomic, strong) NSNumber * commentDBDateLine;
/**
 *  评论点赞数
 */
@property (nonatomic, copy) NSString * commentDigg;
/**
 *  评论来源
 */
@property (nonatomic, copy) NSString * commentLocation;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString * commentMessage;
/**
 *  评论id
 */
@property (nonatomic, strong) NSNumber * commentPid;
/**
 *  评论用户名
 */
@property (nonatomic, copy) NSString * commentUserName;

/**
 *  初始化函数
 *
 *  @param dict 初始化来源字典
 *
 *  @return 评论对象
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  类方法初始化函数
 *
 *  @param dict 初始化来源字典
 *
 *  @return 评论对象
 */
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
