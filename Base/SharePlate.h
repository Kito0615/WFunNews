//
//  SharePlate.h
//  WFunNews
//
//  Created by AnarL on 15/10/15.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SharePlateProtocal <NSObject>

- (void)cancelBtnClicked;
- (void)shareToSinaBtnClicked;
- (void)shareToTencentBtnClicked;
- (void)shareToRenRenBtnClicked;
- (void)shareToQzoneBtnClicked;
- (void)shareToWechatBtnClicked;
- (void)shareToWechatTimelineBtnClicked;

@end

@interface SharePlate : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, assign) id <SharePlateProtocal> delegate;

+ (SharePlate *)sharePlate;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)shareToSina:(UIButton *)sender;
- (IBAction)shareToTencent:(UIButton *)sender;
- (IBAction)shareToRenRen:(UIButton *)sender;
- (IBAction)shareToQZone:(UIButton *)sender;
- (IBAction)shareToWechat:(UIButton *)sender;
- (IBAction)shareToWechatTimeline:(UIButton *)sender;

@end
