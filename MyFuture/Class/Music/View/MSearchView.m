//
//  MSearchView.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/16.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MSearchView.h"

@implementation MSearchView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}


- (void)setUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    _textfield = [[UITextField alloc] init];
    _textfield.delegate = self;
    _textfield.borderStyle = UITextBorderStyleNone;
    [self addSubview:_textfield];
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
    }];
    
    _separteView = [[UIView alloc] init];
    _separteView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_separteView];
    [_separteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.bottom.equalTo(@-5);
        make.height.equalTo(@1);
        make.width.equalTo(@200);
    }];
    
    _searcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searcBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searcBtn];
    [_searcBtn setBackgroundImage:[UIImage imageNamed:@"icon_search@2x.png"] forState:UIControlStateNormal];
    [_searcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];


}

- (void)searchBtnAction
{
    
    [_textfield resignFirstResponder];
    NSLog(@"------searchBtn click!-----");
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _zuijinBlock();
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _sousuoBlock(string);
    return YES;
}
@end
