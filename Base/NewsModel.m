//
//  NewsModel.m
//  WPXap
//
//  Created by AnarL on 15/9/28.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.newsAPIUrl = dict[@"apiurl"];
        self.newsClassName = dict[@"classname"];
        self.newsCommentUrl = dict[@"comment_url"];
        self.newsDateLine = dict[@"dateline"];
        self.newsDBDateLine = dict[@"dbdateline"];
        self.newsFontStyle = dict[@"font_style"];
        self.newsHighLight = dict[@"highlight"];
        self.newsKValue = dict[@"k"];
        self.newsPicUrl = dict[@"pic"];
        self.newsRecommend = dict[@"recommend"];
        self.newsReplies = dict[@"replies"];
        self.newsSummary = dict[@"summary"];
        self.newsTid = dict[@"tid"];
        self.newsTitle = dict[@"title"];
        self.newsTypeName = dict[@"typename"];
        self.newsAuthorName = dict[@"uname"];
        self.newsViewers = dict[@"views"];
        self.newsWebUrl = dict[@"weburl"];
    }
    return self;
}

+(instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[NewsModel alloc] initWithDict:dict];
}

/**
 *  归档方法
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.newsAPIUrl forKey:@"apiurl"];
    [aCoder encodeObject:self.newsClassName forKey:@"classname"];
    [aCoder encodeObject:self.newsCommentUrl forKey:@"comment_url"];
    [aCoder encodeObject:self.newsDateLine forKey:@"dateline"];
    [aCoder encodeObject:self.newsDBDateLine forKey:@"dbdateline"];
    [aCoder encodeObject:self.newsFontStyle forKey:@"font_style"];
    [aCoder encodeObject:self.newsHighLight forKey:@"highlight"];
    [aCoder encodeObject:self.newsKValue forKey:@"k"];
    [aCoder encodeObject:self.newsPicUrl forKey:@"pic"];
    [aCoder encodeObject:self.newsRecommend forKey:@"recommend"];
    [aCoder encodeObject:self.newsReplies forKey:@"replies"];
    [aCoder encodeObject:self.newsSummary forKey:@"summary"];
    [aCoder encodeObject:self.newsTid forKey:@"tid"];
    [aCoder encodeObject:self.newsTitle forKey:@"title"];
    [aCoder encodeObject:self.newsTypeName forKey:@"typename"];
    [aCoder encodeObject:self.newsAuthorName forKey:@"uname"];
    [aCoder encodeObject:self.newsViewers forKey:@"views"];
    [aCoder encodeObject:self.newsWebUrl forKey:@"weburl"];
    
}
/**
 *  解档方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.newsAPIUrl = [aDecoder decodeObjectForKey:@"apiurl"];
        self.newsClassName = [aDecoder decodeObjectForKey:@"classname"];
        self.newsCommentUrl = [aDecoder decodeObjectForKey:@"comment_url"];
        self.newsDateLine = [aDecoder decodeObjectForKey:@"dateline"];
        self.newsDBDateLine = [aDecoder decodeObjectForKey:@"dbdateline"];
        self.newsFontStyle = [aDecoder decodeObjectForKey:@"font_style"];
        self.newsHighLight = [aDecoder decodeObjectForKey:@"highlight"];
        self.newsKValue = [aDecoder decodeObjectForKey:@"k"];
        self.newsPicUrl = [aDecoder decodeObjectForKey:@"pic"];
        self.newsRecommend = [aDecoder decodeObjectForKey:@"recommend"];
        self.newsReplies = [aDecoder decodeObjectForKey:@"replies"];
        self.newsSummary = [aDecoder decodeObjectForKey:@"summary"];
        self.newsTid = [aDecoder decodeObjectForKey:@"tid"];
        self.newsTitle = [aDecoder decodeObjectForKey:@"title"];
        self.newsTypeName = [aDecoder decodeObjectForKey:@"typename"];
        self.newsAuthorName = [aDecoder decodeObjectForKey:@"uname"];
        self.newsViewers = [aDecoder decodeObjectForKey:@"views"];
        self.newsWebUrl = [aDecoder decodeObjectForKey:@"weburl"];
        
    }
    return self;
}



@end
