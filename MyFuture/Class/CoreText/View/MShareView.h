//
//  MShareView.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/8/3.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MShareView : UIView

@property (nonatomic, strong) UIView *backView;


- (instancetype)initWithFrame:(CGRect)frame shareBlock:(void(^)())block;

@end
