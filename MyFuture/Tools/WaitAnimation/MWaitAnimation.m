//
//  MWaitAnimation.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MWaitAnimation.h"

#import "JGProgressHUD.h"

static JGProgressHUD *lastHUD;
@implementation MWaitAnimation


+ (JGProgressHUD *)hud
{
    JGProgressHUD *hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    lastHUD = hud;
    return hud;
}

+ (void)popuMessage:(NSString *)message
{
    [self hud];
    lastHUD.textLabel.text = message;
    [lastHUD showInView:[UIApplication sharedApplication].keyWindow animated:YES];
//    [lastHUD dismissAnimated:YES];
//    lastHUD = nil;
}

+ (void)popuTitle:(NSString *)title
{
    lastHUD.textLabel.text = title;
}


+ (void)popuAnimation
{
    [self hud];
    [lastHUD showInView:[UIApplication sharedApplication].keyWindow animated:YES];

}

+ (void)dissmissAnimation:(BOOL)animation
{
    [lastHUD dismissAnimated:animation];
    lastHUD = nil;
}
@end
