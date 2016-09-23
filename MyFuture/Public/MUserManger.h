//
//  MUserManger.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/6.
//  Copyright © 2016年 hongxinli. All rights reserved.

#import <Foundation/Foundation.h>

@class CustomTabBarController;


typedef NS_ENUM(NSInteger, NetState)
{
    isWiFi = 0,
    is4G,
    isNotLine,
};

@interface MUserManger : NSObject

+ (MUserManger *)shareInstance;

@property (nonatomic, copy) NSString *userCount;    //用户帐号
@property (nonatomic, copy) NSString *passWord;     //用户密码
@property (nonatomic, copy) NSString *icnPath;      //用户图片
@property (nonatomic, assign) NetState NetWorkState;      //网络状态
@property (nonatomic, assign) NSInteger index;      //位置选择编号
@property (nonatomic, strong) CustomTabBarController *controller;

///进入首页
+ (void)userLogin;

///退出
+ (void)userLogout;

///引导页启动
+ (void)userLoginWithGuide;

///跳转至登录界面
+ (void)userLoginCallBack;

///跳转至注册界面
+ (void)userRegis:(BOOL)hiddle;

///歌曲数据库添加歌曲
+ (void)musicTableAddMusic;

@end
