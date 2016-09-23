//
//  MXAlertView.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/6.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MXAlertView.h"


@interface MXAlertView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageIcn;
@property (nonatomic, strong) NSArray *netAry;
@end

@implementation MXAlertView

- (NSArray *)netAry
{
    if (!_netAry) {
        _netAry = @[@"无网络连接",@"以连上WiFi",@"以连上4G"];
    }
    return _netAry;
}

- (instancetype)initWithMessage:(NSString *)message statue:(MXAlertStatue)statue signle:(BOOL)signle arg:(NSArray *)array
{
    self = [super init];
    if (self) {
        [self addViewString:message statue:statue signle:signle arg:array];
    }
    return self;
}



- (instancetype)initWithMessage:(NSString *)message statue:(MXAlertStatue)statue
{
      self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)addViewString:(NSString *)str statue:(MXAlertStatue)statue signle:(BOOL)signle arg:(NSArray *)arg
{
    self.backgroundColor = RGBA(0, 0, 0, 0.8);
    self.frame = [[UIScreen mainScreen] bounds];
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 8;
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@130);
        make.width.equalTo(@180);
    }];
    
    
    //添加图片
    self.imageIcn = [[UIImageView alloc] init];
    switch (statue) {
        case MXAlert_success:
            _imageIcn.image = [UIImage imageNamed:@"layer-correct@2x.png"];
            break;

        case MXAlert_failure:
            _imageIcn.image = [UIImage imageNamed:@"layer-error@2x.png"];
            break;
            
        case MXAlert_doubt:
            _imageIcn.image = [UIImage imageNamed:@"layer-doubt@2x.png"];
            break;
        default:
            break;
    }
    
    [self.backView addSubview:self.imageIcn];
    [self.imageIcn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.top.equalTo(@15);
        make.centerX.equalTo(self);
    }];
    
    self.messageLabel = [[UILabel alloc] init];
    [self.backView addSubview:self.messageLabel];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont systemFontOfSize:15];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(@60);
        make.width.equalTo(self);
    }];
    self.messageLabel.text = str;

    //添加button
    

    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = RGB(0, 156, 229);
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(signalBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *button1 = [[UIButton alloc] init];
    button1.backgroundColor = RGB(0, 156, 229);
    [button1 setTintColor:[UIColor whiteColor]];
    [button1 addTarget:self action:@selector(expandBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (signle) {
        [self.backView addSubview:button];
        [button setTitle:arg[0] forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.bottom.equalTo(@0);
            make.trailing.equalTo(@0);
            make.leading.equalTo(@0);
        }];
    }else{
        [self.backView addSubview:button];
        [self.backView addSubview:button1];
        [button setTitle:arg[0] forState:UIControlStateNormal];
        [button1 setTitle:arg[1] forState:UIControlStateNormal];


        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(@89);
        }];
        
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
            make.width.equalTo(@89);
        }];
    }
    
}


- (instancetype)initWithNetWorkState:(NSInteger)state
{
    self = [super init];
    if (self) {
        [self netWorkChangedWithStatue:state];
    }
    return self;
}


- (void)netWorkChangedWithStatue:(NSInteger)statue

{
    self.frame = CGRectMake(0, -60, 375, 60);
    self.backgroundColor = [UIColor redColor];
    UILabel *message = [[UILabel alloc] init];
    message.font = [UIFont systemFontOfSize:12.0];
    message.textAlignment = NSTextAlignmentLeft;
    message.numberOfLines = 0;
    [self addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@375);
        make.width.equalTo(@60);
    }];
    message.text = self.netAry[statue];
}

- (void)netWorkStatueChanged
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
   [UIView animateWithDuration:3.0 animations:^{
       self.frame = CGRectMake(0, 0, 375, 60);
   } completion:^(BOOL finished) {
       [UIView animateWithDuration:3.0 animations:^{
           self.frame = CGRectMake(0, -60, 375, 60);

       } completion:^(BOOL finished) {
           [self removeFromSuperview];
       }];
   }];
}


- (void)showWarm
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.alpha = 0.2;
    [window addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];

}

- (void)disMissAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.2;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}


- (void)signalBtnAction
{
    self.signleBlock();
}

- (void)expandBtnAction
{
    self.expandBlock();
}
@end
