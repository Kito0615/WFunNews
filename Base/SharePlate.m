//
//  SharePlate.m
//  WFunNews
//
//  Created by qianfeng on 15/10/15.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import "SharePlate.h"

@implementation SharePlate

+ (SharePlate *)sharePlate
{
    NSArray * nibViewArr = [[NSBundle mainBundle] loadNibNamed:@"SharePlate" owner:nil options:nil];
    
    return [nibViewArr lastObject];
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self.delegate cancelBtnClicked];
}

- (IBAction)shareToSina:(UIButton *)sender {
    [self.delegate shareToSinaBtnClicked];
}

- (IBAction)shareToTencent:(UIButton *)sender {
    [self.delegate shareToTencentBtnClicked];
}

- (IBAction)shareToRenRen:(UIButton *)sender {
    [self.delegate shareToRenRenBtnClicked];
}

- (IBAction)shareToQZone:(UIButton *)sender {
    [self.delegate shareToQzoneBtnClicked];
}

- (IBAction)shareToWechat:(UIButton *)sender {
    [self.delegate shareToWechatBtnClicked];
}

- (IBAction)shareToWechatTimeline:(UIButton *)sender {
    [self.delegate shareToWechatTimelineBtnClicked];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
