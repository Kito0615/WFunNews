//
//  LLCollectionDataManager.m
//  WPXap
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#define DATABASE_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Collection.db"]

#import "LLCollectionDataManager.h"


static LLCollectionDataManager * manager;

@implementation LLCollectionDataManager


- (void)insertIntoCollectionWithInsertStr:(NSString *)insertStr withNewsModel:(NewsModel *)model NewsContentString:(NSString *)contentStr
{
    _dataBase = [[FMDatabase alloc] initWithPath:DATABASE_PATH];
    
    NSLog(@"%@", DATABASE_PATH);
    
    BOOL createDataBaseTag = [_dataBase open];
    
    if (createDataBaseTag) {
        NSLog(@"打开或创建数据库成功!");
    } else {
        NSLog(@"打开或创建数据库失败!");
    }
    
    NSString * createTableStr = @"CREATE TABLE IF NOT EXISTS Collection (collectionID INTEGER PRIMARY KEY AUTOINCREMENT,  newsID VARCHAR(256), newsInfo BLOB, newsContent VARCHAR(256))";
    BOOL createTableTag = [_dataBase executeUpdate:createTableStr];
    
    if (createTableTag) {
        NSLog(@"创建或打开表格成功!");
    } else {
        NSLog(@"创建或打开表格失败!");
    }
    
    NSString * newsID = model.newsTid.stringValue;
    NSData * newsInfo = [NSKeyedArchiver archivedDataWithRootObject:model];
    
    BOOL insertTag = [_dataBase executeUpdate:insertStr, newsID, newsInfo, contentStr];
    
    if (insertTag) {
        NSLog(@"插入数据成功!");
    } else {
        NSLog(@"插入数据失败!");
    }
    
    [_dataBase close];
    
}

+ (instancetype)sharedManager
{
    if (!manager) {
        return [[LLCollectionDataManager alloc] init];
    }
    return manager;
}


- (FMResultSet *)loadFromLocalDataBaseWithQueryStr:(NSString *)queryStr
{
    _dataBase = [[FMDatabase alloc] initWithPath:DATABASE_PATH];
    
    BOOL createDataBaseTag = [_dataBase open];
    
    if (createDataBaseTag) {
        NSLog(@"打开或创建数据库成功!");
    } else {
        NSLog(@"打开或创建数据库失败!");
    }
    
    FMResultSet * results = [_dataBase executeQuery:queryStr];
    return results;
}

- (void)deleteFromDataBaseWithDeleteStr:(NSString *)deleteString
{
    _dataBase = [[FMDatabase alloc] initWithPath:DATABASE_PATH];
    BOOL createDataBaseTag = [_dataBase open];
    
    if (createDataBaseTag) {
        NSLog(@"打开或创建数据库成功!");
    } else {
        NSLog(@"打开或创建数据库失败!");
    }
    
    BOOL deleteTag = [_dataBase executeUpdate:deleteString];
    
    if (deleteTag) {
        NSLog(@"删除数据成功!");
    } else {
        NSLog(@"删除数据失败!");
    }
    
}



@end
