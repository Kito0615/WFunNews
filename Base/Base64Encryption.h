//
//  Base64Encryption.h
//  WPXap
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __BASE64 (text) [Base64Encryption base64StringFromText:text]
#define __TEXT (base64) [Base64Encryption textFromBase64String:base64]

@interface Base64Encryption : NSObject

/**
 *  将普通字符串加密为base64格式字符串
 *
 *  @param text 要加密的字符串
 *
 *  @return base64加密后的字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 *  将base64格式字符串解密为普通字符串
 *
 *  @param base64 要解密的base64格式字符串
 *
 *  @return 解密后的普通字符串
 */
+ (NSString *)textFromBase64String:(NSString *)base64;



@end
