//
//  MMoiveBar.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/7.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMoiveBar.h"

@interface MMoiveBar ()

@property (nonatomic, strong) UIImageView *icn;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation MMoiveBar

- (instancetype)initWithIcnPath:(NSString *)icnPath
{
    self = [super init];
    if (self) {
        [self addUserIcnWithPath:icnPath];
    }
    return self;
}


- (void)addUserIcnWithPath:(NSString *)path
{
    self.barTintColor = RGBA(222, 222, 222, 0.8);
    self.barStyle = 2;
    self.
    self.frame = CGRectMake(0, -20, 375, 64);
    _icn = [[UIImageView alloc] init];
    _icn.layer.cornerRadius = 20;
    _icn.clipsToBounds = YES;
    _icn.image = [UIImage imageNamed:path];
    [self addSubview:_icn];
    [_icn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.bottom.equalTo(@-5);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
}
@end
