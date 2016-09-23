//
//  MShareView.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/8/3.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MShareView.h"

@interface MShareView ()

@property (nonatomic, copy) void(^shareBlcok)();

@end

@implementation MShareView

- (instancetype)initWithFrame:(CGRect)frame shareBlock:(void (^)())block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUI];
        _shareBlcok = block;

    }
    return self;
}


- (void)setUI

{
    self.backgroundColor = [UIColor darkGrayColor];
    self.alpha = 0.6;
//
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 600, 375, 300)];
    _backView.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blackColor];
    btn.frame = CGRectMake(50, 50, 100, 30);
    btn.titleLabel.text = @"分享";
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(10, 50, 100, 30);
//    cancelBtn.titleLabel.text = @"取消";
//    cancelBtn.titleLabel.textColor = [UIColor blackColor];
//    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:btn];
    [self addSubview:self.backView];
    
}

- (void)share:(UIButton *)sender
{
    if (_shareBlcok) {
        _shareBlcok();
    }
}

- (void)cancel:(UIButton *)sender
{
 
    CGRect frame = self.backView.frame;
    CGPoint point = CGPointMake(0, 600);
    frame.origin = point;
    self.backView.frame = frame;
    [self removeFromSuperview];
/*
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = self.backView.frame;
        CGPoint point = CGPointMake(0, 600);
        frame.origin = point;
        self.backView.frame = frame;

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];*/
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGRect frame = self.backView.frame;
    CGPoint point = CGPointMake(0, 600);
    frame.origin = point;
    self.backView.frame = frame;
    [self removeFromSuperview];
/*
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = self.backView.frame;
        CGPoint point = CGPointMake(0, 600);
        frame.origin = point;
        self.backView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];*/
}
@end
