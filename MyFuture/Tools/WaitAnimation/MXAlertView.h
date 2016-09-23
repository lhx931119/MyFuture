//
//  MXAlertView.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/6.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MXAlertStatue)
{
    MXAlert_success = 0,//成功提示
    MXAlert_failure,    //失败提示
    MXAlert_none,       //文本提示
    MXAlert_doubt,      //感叹号提示
};

@interface MXAlertView : UIView

@property (nonatomic, copy) void(^signleBlock)();

@property (nonatomic, copy) void(^expandBlock)();

//单个按钮点击事件

- (instancetype)initWithMessage:(NSString *)message statue:(MXAlertStatue)statue signle:(BOOL)signle arg:(NSArray *)array;

- (instancetype)initWithMessage:(NSString *)message statue:(MXAlertStatue)statue;

- (instancetype)initWithNetWorkState:(NSInteger)state;

- (void)showWarm;

- (void)netWorkStatueChanged;

- (void)disMissAnimation:(BOOL)animation;

@end
