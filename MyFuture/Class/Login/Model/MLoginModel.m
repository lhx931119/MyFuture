//
//  MLoginModel.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/6.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MLoginModel.h"
#import "MWaitAnimation.h"
#import "MSqiteManger.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "MXAlertView.h"
#import "MUserManger.h"
@implementation MLoginModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initialBind];
    }
    return self;
}

//初始化绑定
- (void)initialBind
{
    //监听帐号的属性值改变，把他们聚合成一个信号
    _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, password)] reduce:^id{
        return @(_account.length && _password.length);
    }];
    
    //处理登录业务逻辑
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [MWaitAnimation popuMessage:@"请稍等...."];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSLog(@"------点击了登录------");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSString *where = [NSString stringWithFormat:@"%@='%@' and %@='%@'",mUserInformationTable_userCount, _account, mUserInformationTable_passWord, _password];
            MSqiteManger *manger = [MSqiteManger shareMSqliteManger];
            NSArray *ary = [manger search:mUserInformationTable column:nil where:where orderBy:nil limit:0 offset:0];
            BOOL result = ary.count ? YES : NO;
                //模拟网络延迟
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [MWaitAnimation dissmissAnimation:YES];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                    if (result) {
                        
                        if (self.isWrite) {
                            
                            NSDictionary *dic = @{@"key":_account,
                                                  @"value":_password};
                            UserDefaultWrite(MUserInfo, dic);
                            UserDefaultSynchronize;
                        }else{
                            NSDictionary *dic = @{@"key":_account,
                                                  @"value":@""};
                            UserDefaultWrite(MUserInfo, dic);
                            UserDefaultSynchronize;
                        }
                        
                        [MUserManger userLogin];
                        
                    }else{
                        MXAlertView *alertView = [[MXAlertView alloc] initWithMessage:@"信息错误!" statue:MXAlert_failure signle:NO arg:@[@"注册", @"取消"]];
                       
                        __weak typeof(MXAlertView) *weakAlert = alertView;
                        __weak typeof(self) weakSelf = self;
                        alertView.signleBlock = ^(){
                            [weakAlert disMissAnimation:YES];
                            weakSelf.callBack();
                        };
                        
                        alertView.expandBlock = ^(){
                            [weakAlert disMissAnimation:YES];
                        };
                        [alertView showWarm];
                        
                    }
                   
                    //数据传送完毕，必须调用完成，否则命令永远处于执行状态
                    [subscriber sendCompleted];
                });
        
           
            return nil;
        }];
    }];
    
    //监听登录产生的数据
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
            NSLog(@"------x = %@------", x);
    }];
    
    //监听登录状态
    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            NSLog(@"-----正在登录。。。。。。----");
        }else{
            NSLog(@"----登录成功。。。。。。------");
        }
    }];
}
@end
