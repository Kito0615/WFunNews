//
//  CommentModel.m
//  WPXap
//
//  Created by AnarL on 15/9/29.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.commentPid = dict[@"pid"];
        self.commentUserName = dict[@"uname"];
        self.commentMessage = dict[@"message"];
        self.commentLocation = dict[@"location"];
        self.commentDigg = dict[@"digg"];
        self.commentDBDateLine = dict[@"dbdateline"];
        self.commentDateLine = dict[@"dateline"];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[CommentModel alloc] initWithDict:dict];
}

@end
