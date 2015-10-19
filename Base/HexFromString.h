//
//  HexFromString.h
//  WPXap
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexFromString : NSObject

/**
 *  十六进制字符串
 */
@property (nonatomic, copy) NSString * hexString;
/**
 *  RGB颜色值数组
 */
@property (nonatomic, strong) NSArray * hexRGBValue;

/**
 *  @brief 利用颜色的十六进制字符串转换为RGB颜色十进制数组
 *
 *  @param hexStr 十六进制字符串
 *
 *  @return RGB颜色值数组
 */
- (NSArray *)RGBWithHexString:(NSString *)hexStr;

@end
