//
//  MRegisHeadView.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MRegisHeadView.h"

@implementation MRegisHeadView

- (instancetype)initWithFrame:(CGRect)frame btn:(BOOL)hiddle callBack:(void (^)())callBack
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.hidden = hiddle;
//        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"layer-cancel-normal@2x.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"layer-cancel-click@2x.png"] forState:UIControlStateHighlighted];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setBackgroundColor:RGB(22, 115, 243)];
       [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
           callBack();
       }];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@80);
            make.height.equalTo(@70);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"注册";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.equalTo(@30);
        }];
//        self.backgroundColor = RGB(22, 115, 243);
    }
    return self;
}

@end
