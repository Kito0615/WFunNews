//
//  NewsModel.h
//  WPXap
//
//  Created by AnarL on 15/9/28.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject <NSCoding>

/**
 *  新闻api链接
 */
@property (nonatomic, copy) NSString * newsAPIUrl;
/**
 *  新闻二级类别名称
 */
@property (nonatomic, copy) NSString * newsClassName;
/**
 *  新闻评论列表
 */
@property (nonatomic, copy) NSString * newsCommentUrl;
/**
 *  新闻发表时间（格式化）
 */
@property (nonatomic, copy) NSString * newsDateLine;
/**
 *  新闻发表时间（未格式化）
 */
@property (nonatomic, copy) NSString * newsDBDateLine;
/**
 *  新闻字体样式
 */
@property (nonatomic, strong) NSDictionary * newsFontStyle;
/**
 *  新闻标题高亮
 */
@property (nonatomic, copy) NSString * newsHighLight;
/**
 *  新闻K值
 */
@property (nonatomic, strong) NSNumber * newsKValue;
/**
 *  新闻图片地址
 */
@property (nonatomic, copy) NSString * newsPicUrl;
/**
 *  新闻推荐
 */
@property (nonatomic, strong) NSNumber * newsRecommend;
/**
 *  新闻回复数
 */
@property (nonatomic, strong) NSNumber * newsReplies;
/**
 *  新闻简介
 */
@property (nonatomic, copy) NSString * newsSummary;
/**
 *  新闻id
 */
@property (nonatomic, strong) NSNumber * newsTid;
/**
 *  新闻标题
 */
@property (nonatomic, copy) NSString * newsTitle;
/**
 *  新闻一级类别名称
 */
@property (nonatomic, copy) NSString * newsTypeName;
/**
 *  新闻发表人
 */
@property (nonatomic, copy) NSString * newsAuthorName;
/**
 *  新闻浏览量
 */
@property (nonatomic, strong) NSNumber * newsViewers;
/**
 *  新闻web链接
 */
@property (nonatomic, copy) NSString * newsWebUrl;

/**
 *  @brief 初始化函数
 *
 *  @param dict 初始化源字典
 */
- (instancetype)initWithDict:(NSDictionary *)dict;
/**
 *  @brief 类方法初始化函数
 *
 *  @param dict 初始化源字典
 */
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
