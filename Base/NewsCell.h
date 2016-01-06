//
//  NewsCell.h
//  WPXap
//
//  Created by AnarL on 15/9/28.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
/**
 *  新闻图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *newsPic;
/**
 *  新闻标题标签
 */
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
/**
 *  新闻相关信息标签
 */
@property (weak, nonatomic) IBOutlet UILabel *newsInfo;
/**
 *  新闻简介标签
 */
@property (weak, nonatomic) IBOutlet UILabel *newsSummary;

@end
