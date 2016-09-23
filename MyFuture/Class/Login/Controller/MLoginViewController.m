//
//  MLoginViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/6.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MLoginViewController.h"
#import "MNewRegisViewController.h"
#import "MLoginModel.h"
#import "MUserManger.h"

@interface MLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
- (IBAction)settingAction:(UITapGestureRecognizer *)sender;
- (IBAction)switchAction:(UISwitch *)sender;
- (IBAction)loginAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (nonatomic, strong) MLoginModel *model;

@end

@implementation MLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setapperance];
    
    [self connenctSignal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//设置外观
- (void)setapperance
{
    [self.navigationController.navigationBar setHidden:YES];
    self.backView.layer.cornerRadius = 5.0;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor grayColor].CGColor;
}

//视图模型绑定
- (void)connenctSignal
{
    NSDictionary *dic = UserDefaultRead(MUserInfo);
    
    if (dic.count) {
        self.accountField.text = dic[@"key"];
        self.passwordField.text = dic[@"value"];
    }
    
    //给模型的属性绑上信号
    //只要帐号、密码文本框改变就会给model的对应属性赋值
    RAC(self.model, account) = self.accountField.rac_textSignal;
    RAC(self.model, password) = self.passwordField.rac_textSignal;
    //绑定登录按钮
    RAC(self.loginBtn, enabled) = self.model.enableLoginSignal;
    //绑定选择控制器
    self.model.isWrite = self.switchBtn.on;
    __weak typeof(self) weakSelf = self;
    self.model.callBack = ^(){
        MNewRegisViewController *regis = [[MNewRegisViewController alloc] init];
        regis.isHiddle = NO;
    [weakSelf.navigationController pushViewController:regis animated:YES];
        
    };
    //监听登录按钮点击
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //执行登陆事件
        [self.model.loginCommand execute:nil];
        }];
    
}

#pragma mark ---setter 
- (MLoginModel *)model
{
    if (!_model) {
        _model = [[MLoginModel alloc] init];
    }
    return _model;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)settingAction:(UITapGestureRecognizer *)sender {
    
    NSLog(@"----手势点击--");
}

- (IBAction)switchAction:(UISwitch *)sender {
    self.model.isWrite = sender.on;
}

- (IBAction)loginAction:(UIButton *)sender {
}
@end
