//
//  GuideViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "GuideViewController.h"
#import "CustomBtn.h"
#import "Custom.h"
#import "CustomTabBarController.h"
#import "AppDelegate.h"
#import "MSqiteManger.h"
#import "MLoginViewController.h"
#import "MNewRegisViewController.h"
#import "MRegisViewController.h"
#import "MGuideView.h"
#import "MUserManger.h"
@interface GuideViewController ()

//@property (nonatomic, strong) Custom *guideView;

@property (nonatomic, strong)  MGuideView *guideView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.guideView];

    [self setGuideViewAndGuideViewAction];
    
    [self.view addSubview:self.guideView];
    
//    self.navigationController.navigationBar.translucent = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}
#pragma mark ----setter

- (MGuideView *)guideView
{
    if (!_guideView) {
        self.guideView = [[MGuideView alloc] initWithFrame:self.view.bounds];
    }
    return _guideView;
}
#pragma mark ---privte
- (void)setGuideViewAndGuideViewAction
{
    [[self.guideView  rac_signalForSelector:@selector(btnAction:)] subscribeNext:^(id x) {
        NSArray *array = x;
        CustomBtn *btn = array[0];
        if (btn.tag == 1000) {
            [self registerAction];
        }else{
            [self loginAction];
        }
        
//        if ([array[0] isEqual:self.guideView.registerBtn]) {
//            NSLog(@"----注册按钮被点击----");
//        }else{
//            NSLog(@"----登录按钮被点击----");
//        }
    }];
    [self.view addSubview:_guideView];
}

#pragma mark ---loginAction
- (void)loginAction
{
    

   
    [MUserManger userLoginCallBack];
    
//    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//    if (delegate.window.rootViewController) {
//        delegate.window.rootViewController = nil;
//       delegate.window.rootViewController = [[CustomTabBarController alloc] init];
//        return;
//    }
//    delegate.window.rootViewController = [[CustomTabBarController alloc] init];
    /*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *userCount = @"15236761959";
    NSString *passWord = @"123456";
    
    NSArray *keys = @[mUserInformationTable_userCount, mUserInformationTable_passWord, mUserInformationTable_date];
    NSArray *values = @[userCount, passWord, [formatter stringFromDate:[NSDate date]]];
   BOOL result = [[MSqiteManger shareMSqliteManger] insert:mUserInformationTable insertKey:keys insertValue:values];
    
    NSLog(@"----%d----", result);*/
  
    /*
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'", mUserInformationTable_userCount, @"15236761959"];
  int result =   [[MSqiteManger shareMSqliteManger] rowCount:mUserInformationTable where:where];
    NSLog(@"---%d----", result);*/
    
/*
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'", mUserInformationTable_userCount, @"15236761959"];
  BOOL result = [[MSqiteManger shareMSqliteManger] delete:mUserInformationTable where:where];
    NSLog(@"---%d---", result);*/
//拨打电话
    
//        NSString *phoneNumber = @"13623761209";
//
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];
}

 
- (void)registerAction
{
    
    [MUserManger userRegis:YES];
//    NSString *where = [NSString stringWithFormat:@"%@ = '%@'", mUserInformationTable_userCount, @"15236761959"];
//    NSArray *array = [[MSqiteManger shareMSqliteManger] search:mUserInformationTable column:0 where:where orderBy:0 limit:0 offset:0];
//    NSLog(@"----%@----", array);
}


@end
