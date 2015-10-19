//
//  LLCollectionDataManager.h
//  WPXap
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "NewsModel.h"

@interface LLCollectionDataManager : NSObject
{
    FMDatabase * _dataBase;
}

+ (instancetype)sharedManager;

- (void)insertIntoCollectionWithInsertStr:(NSString *)insertStr withNewsModel:(NewsModel *)model NewsContentString:(NSString *)contentStr;

- (FMResultSet *)loadFromLocalDataBaseWithQueryStr:(NSString *)queryStr;

- (void)deleteFromDataBaseWithDeleteStr:(NSString *)deleteString;


@end
