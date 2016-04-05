//
//  UIImage+GifToArray.m
//  WFunNews
//
//  Created by AnarL on 16/1/31.
//  Copyright © 2016年 AnarL. All rights reserved.
//

#import "UIImage+GifToArray.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (GifToArray)

+ (NSArray *)gifToArray:(NSString *)gifPath
{
    NSData * gifData = [NSData dataWithContentsOfFile:gifPath];
    
    NSMutableArray * frames = [[NSMutableArray alloc] init];
    
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
    
    CGFloat animationTime = 0.0f;
    
    if (src) {
        size_t count = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:count];
        for (size_t i = 0; i < count; i ++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary * properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary * frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber * delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            
            if (imageRef) {
                [frames addObject:[UIImage imageWithCGImage:imageRef]];
                CGImageRelease(imageRef);
            }
        }
        CFRelease(src);
    }
    return frames;
}

@end
