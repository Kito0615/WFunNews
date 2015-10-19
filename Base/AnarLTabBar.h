//
//  AnarLTabBar.h
//  SinaNews
//
//  Created by qianfeng on 15/9/15.
//  Copyright (c) 2015年 AnarL. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MyTabBarButton.h"

@class AnarLTabBar;

@protocol AnarTabBarDelegate <NSObject>

@optional

/**
 *  @brief tabbar点击事件
 *
 *  @param tabbar 当前tabbar
 *  @param from   当前选中视图控制器索引
 *  @param to     即将选中视图控制器索引
 */
- (void)tabBar:(AnarLTabBar *)tabbar didselectButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface AnarLTabBar : UIView
{
    /**
     *  自定义tabbar按钮
     */
    MyTabBarButton * _selectedBtn;
}
/**
 *  代理
 */
@property (nonatomic, assign) id<AnarTabBarDelegate>delegate;

@end
