//
//  MUserManger.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/6.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MUserManger.h"
#import "AppDelegate.h"
#import "GuideViewController.h"
#import "CustomTabBarController.h"
#import "MUserViewController.h"
#import "MLoginViewController.h"
#import "MNewRegisViewController.h"
#import "RESideMenu.h"
#import "MSqiteManger.h"


@implementation MUserManger

+ (MUserManger *)shareInstance
{
    static MUserManger *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[MUserManger alloc] init];
        manger.index = 0;
    });
    return manger;
}

+ (void)userLogin
{
    
    MUserViewController *user = [[MUserViewController alloc] init];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    if (delegate.window.rootViewController) {
        delegate.window.rootViewController = nil;
        
        CustomTabBarController *custom = [[CustomTabBarController alloc] init];

//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:custom];
        
//        custom.selectIndex = [self shareInstance].index;
        
        RESideMenu *slideMenu = [[RESideMenu alloc] initWithContentViewController:custom leftMenuViewController:user rightMenuViewController:nil];
        slideMenu.menuPreferredStatusBarStyle = 1;
        slideMenu.contentViewShadowColor = [UIColor blackColor];
        slideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
        slideMenu.contentViewShadowOpacity = 0.6;
        slideMenu.contentViewShadowRadius = 12;
        slideMenu.contentViewShadowEnabled = YES;
        delegate.window.rootViewController = slideMenu;
        return;
    }
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[CustomTabBarController alloc] init]];
//    delegate.window.rootViewController = nav;
    
        delegate.window.rootViewController = [[CustomTabBarController alloc] init];

}

+ (void)userLogout
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [self shareInstance].index = 0;
    if (delegate.window.rootViewController) {
        delegate.window.rootViewController = nil;
        [self userLoginCallBack];
    }
}

+ (void)userRegis:(BOOL)hiddle
{
//    UINavigationController *nav = [[UINavigationController alloc ] initWithRootViewController:[[MNewRegisViewController alloc] init]];
    MNewRegisViewController *regis = [[MNewRegisViewController alloc] init];
    regis.isHiddle = hiddle;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = regis;
}

+ (void)userLoginWithGuide
{
  
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [[GuideViewController alloc] init];
    UserDefaultWrite(MIsFirstLanuch, @YES);
    UserDefaultSynchronize;

}


+ (void)userLoginCallBack
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MLoginViewController alloc] init]];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = nav;
}


+ (void)musicTableAddMusic
{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"music.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dic = array[i];
        NSArray *value = @[dic[@"name"], dic[@"address"], dic[@"singer"]];
        NSArray *key = @[mUserMusicTable_name, mUserMusicTable_address, mUserMusicTable_signer];
        [[MSqiteManger shareMSqliteManger] insert:mUserMusicTable insertKey:key insertValue:value];
    }
}
@end
