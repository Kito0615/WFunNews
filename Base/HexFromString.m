//
//  HexFromString.m
//  WPXap
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 龙乐. All rights reserved.
//

#import "HexFromString.h"

@implementation HexFromString

- (NSArray *)RGBWithHexString:(NSString *)hexStr
{
    self.hexString = hexStr;
    
    NSString * colorStr = [hexStr substringFromIndex:1];
    
    NSInteger redValue = strtol([[colorStr substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
    NSInteger greenValue = strtol([[colorStr substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
    NSInteger blueValue = strtol([[colorStr substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);;
    
    self.hexRGBValue = @[[NSString stringWithFormat:@"%d", redValue],[NSString stringWithFormat:@"%d", greenValue],[NSString stringWithFormat:@"%d", blueValue]];
    
    return self.hexRGBValue;    
    
}


@end
