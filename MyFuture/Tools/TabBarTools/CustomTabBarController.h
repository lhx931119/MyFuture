//
//  CustomTabBarController.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/1/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarView;

@interface CustomTabBarController : UIViewController

//
//@property (nonatomic, copy) void(^touchBtnBlock)(NSInteger index);
//@property (nonatomic, copy) void(^touchCenterBtnBlock)();
//
@property (nonatomic, strong) TabBarView *tabbar;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, assign) NSInteger selectIndex;
@end
