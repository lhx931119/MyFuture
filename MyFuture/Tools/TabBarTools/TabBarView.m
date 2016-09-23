//
//  TabBarView.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/1/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "TabBarView.h"

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_0"]];
    [_tabbarView setFrame:CGRectMake(0, 9, self.frame.size.width, 51)];
    [_tabbarView setUserInteractionEnabled:YES];
    
    _tabbarViewCenter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_mainbtn_bg"]];
    
    _tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
    
    [_tabbarViewCenter setUserInteractionEnabled:YES];
    
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_center.adjustsImageWhenHighlighted = YES;
    [_button_center setBackgroundImage:[UIImage imageNamed:@"tabbar_mainbtn"] forState:UIControlStateNormal];
    
    [_button_center setFrame:CGRectMake(0, 0, 46, 46)];
    
    _button_center.center = CGPointMake(_tabbarViewCenter.bounds.size.width/2.0, _tabbarViewCenter.bounds.size.height/2.0 + 5) ;
    [_button_center addTarget:self action:@selector(centerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarViewCenter addSubview:_button_center];
    
    [self addSubview:_tabbarView];
    [self addSubview:_tabbarViewCenter];
    
    [self layoutBtn];
    
}

-(void)layoutBtn
{
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_button_1 setBackgroundColor:[UIColor blueColor]];
    [_button_1 setFrame:CGRectMake(0, 0, 64, 60)];
    [_button_1 setTag:101];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setFrame:CGRectMake(65, 0, 64, 60)];
    [_button_2 setTag:102];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setFrame:CGRectMake(202, 0, 64, 60)];
    [_button_3 setTag:103];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setFrame:CGRectMake(267, 0, 64, 60)];
    [_button_4 setTag:104];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tabbarView addSubview:_button_1];
    [_tabbarView addSubview:_button_2];
    [_tabbarView addSubview:_button_3];
    [_tabbarView addSubview:_button_4];
    
}

- (void)centerBtnAction:(UIButton *)sender
{
    self.touchCenterBtnBlock();
}

- (void)btn1Click:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 101:
        {
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            self.touchBtnBlock(0);
            break;
        }
        case 102:
        {
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            self.touchBtnBlock(1);
            break;
        }
        case 103:
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            self.touchBtnBlock(2);

            break;
        case 104:
//            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            self.touchBtnBlock(3);
            break;
        default:
            break;
    }
}


@end