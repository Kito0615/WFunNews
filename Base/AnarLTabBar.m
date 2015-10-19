//
//  AnarLTabBar.m
//  SinaNews
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//

#define TABBAR_COUNT 3

#import "AnarLTabBar.h"

@implementation AnarLTabBar

/**
 *  @brief 初始化函数
 *
 *  @param frame 视图位置、大小
 *
 *  @return 视图对象
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatButtons];
    }
    return self;
}

/**
 *  创建视图控制器按钮
 */
-(void)creatButtons
{
    
    NSArray * unSelectArr = @[ @"tabbar_picture",@"tabbar_news", @"tabbar_setting"];
    NSArray * selectArr = @[ @"tabbar_picture_hl",@"tabbar_news_hl", @"tabbar_setting_hl"];
    
    NSArray * titleArr = @[@"即时新闻",@"热点新闻",@"系统设置"];
    
    
    for (int i = 0; i < TABBAR_COUNT; i++) {
        
        MyTabBarButton * btn = [MyTabBarButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:unSelectArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectArr[i]] forState:UIControlStateSelected];
        
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:240/255.0 green:94/255.0 blue:99/255.0 alpha:1] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        btn.tag = 100 + i;
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = btn;
        }
        
        [self addSubview:btn];
    }
}

/**
 *  布局tabbar按钮
 */
-(void)layoutSubviews
{
    CGFloat buttonW = self.bounds.size.width / TABBAR_COUNT;
    CGFloat buttonH = self.bounds.size.height;
    
    CGFloat buttonY = 0;
    CGFloat buttonX = buttonW;
    
    
    for (int i = 0; i < TABBAR_COUNT; i++) {
        MyTabBarButton * btn = (id)[self viewWithTag:(i + 100)];
        
        btn.frame = CGRectMake(buttonX * i, buttonY, buttonW, buttonH);
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-buttonH / 2 + 10, buttonW / 3, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(buttonH / 2, -buttonW / 4, 0, 0)];
        
    }
}

/**
 *  按钮点击事件
 *
 *  @param btn 即将选中的按钮
 */
-(void)btnClicked:(MyTabBarButton *)btn
{
    if (_selectedBtn != btn) {
        [self.delegate tabBar:self didselectButtonFrom:_selectedBtn.tag - 100 to:btn.tag - 100];
        _selectedBtn.selected = NO;
        btn.selected = YES;
        _selectedBtn = btn;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
