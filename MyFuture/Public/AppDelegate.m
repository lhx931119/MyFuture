//
//  AppDelegate.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/1/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MSqiteManger.h"
#import "MLoginViewController.h"
#import "MUserViewController.h"
#import "MUserManger.h"
#import "MLogoutViewController.h"
#import "MMusic.h"
#import "Reachability.h"
#import "MXAlertView.h"

@interface AppDelegate ()

@property (nonatomic, strong) Reachability *reach;
@property (nonatomic, assign) NSInteger netWorkStatue;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
  
    
    [[MSqiteManger shareMSqliteManger] createTableWithName:mUserInformationTable];
    [[MSqiteManger shareMSqliteManger] createTableWithName:mUserMusicTable];
    [[MSqiteManger shareMSqliteManger] createTableWithName:mUserMovieTable];
     [[MSqiteManger shareMSqliteManger] createTableWithName:mUserDNFTable];

    _netWorkStatue = 3;

   BOOL isFirstLaunch = UserDefaultRead(MIsFirstLanuch);

    if (!isFirstLaunch) {
      
       [MUserManger userLoginWithGuide];
        
        //第一次启动歌曲数据库添加歌单
        [MUserManger musicTableAddMusic];
       
    }else{
        
        [MUserManger userLoginCallBack];
    }
    
    
    //监测网络变化
    [self netWorkMonitorSituation];
    
    //注册微信

   [WXApi registerApp:@"wx769fa138e1d9ab75"];

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
//    self.window.rootViewController = nav;
    return YES;
}

///监测网络变化
- (void)netWorkMonitorSituation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [_reach startNotifier];

}


- (void)reachabilityChanged:(NSNotification *)notification
{
    
    Reachability *reach = [notification object];
    MXAlertView *netWorkStatueView =  [[MXAlertView alloc] initWithNetWorkState:reach.currentReachabilityStatus];
    
    NSLog(@"%d", reach.currentReachabilityStatus);
    
    switch (reach.currentReachabilityStatus) {
        case 0:
            [netWorkStatueView netWorkStatueChanged];
            //没有网络连接
            _netWorkStatue = 0;
            [MUserManger shareInstance].NetWorkState = isNotLine;
            break;
        case 1:
            if (_netWorkStatue == 0) {
                [netWorkStatueView netWorkStatueChanged];
            }
            //WiFi链接
            _netWorkStatue = 1;
            [MUserManger shareInstance].NetWorkState = isWiFi;
            break;
        case 2:
            //4G网络连接
            [MUserManger shareInstance].NetWorkState = is4G;
            _netWorkStatue = 2;
            [netWorkStatueView netWorkStatueChanged];
            break;
        default:
            break;
    }
    NSParameterAssert([reach isKindOfClass:[reach class]]);
    
    
    
    
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
     // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
