//
//  MWaitAnimation.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWaitAnimation : NSObject

+ (void)popuMessage:(NSString *)message;

+ (void)dissmissAnimation:(BOOL)animation;

+ (void)popuTitle:(NSString *)title;

+ (void)popuAnimation;

@end
