//
//  NSString+EditString.m
//  NSStringCategory
//
//  Created by qianfeng on 15/10/18.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import "NSString+EditString.h"

@implementation NSString (EditString)

+ (NSString *)insertString:(NSString *)insertStr intoString:(NSString *)sourceStr beforeSubString:(NSString *)subString
{
    NSMutableString * copySourceString = [NSMutableString stringWithString:sourceStr];
    
    NSRange subStringRange = [copySourceString rangeOfString:subString options:NSBackwardsSearch range:NSMakeRange(0, sourceStr.length)];
    
    while (subStringRange.location != NSNotFound) {
        NSRange lastRange = subStringRange;
        
        [copySourceString insertString:insertStr atIndex:lastRange.location];
        
        subStringRange = [copySourceString rangeOfString:subString options:NSBackwardsSearch range:NSMakeRange(0, lastRange.location)];
        
    }
    return copySourceString;
}

+ (NSString *)insertString:(NSString *)insertStr intoString:(NSString *)sourceStr afterSubString:(NSString *)subString
{
    NSMutableString * copySourceString = [NSMutableString stringWithString:sourceStr];
    
    NSRange subStringRange = [copySourceString rangeOfString:subString options:NSBackwardsSearch range:NSMakeRange(0, sourceStr.length)];
    
    while (subStringRange.location != NSNotFound) {
        NSRange lastRange = subStringRange;
        
        [copySourceString insertString:insertStr atIndex:lastRange.location + lastRange.length];
        
        subStringRange = [copySourceString rangeOfString:subString options:NSBackwardsSearch range:NSMakeRange(0, lastRange.location)];
    }
    return copySourceString;
}


@end
