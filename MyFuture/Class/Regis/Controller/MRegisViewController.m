//
//  MRegisViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/29.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MRegisViewController.h"

@interface MRegisViewController ()
@property (weak, nonatomic) IBOutlet UIView *firstBackView;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *adressField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (weak, nonatomic) IBOutlet UIButton *callBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

/*---------------------------------------------------------*/

@property (weak, nonatomic) IBOutlet UIView *secondBackView;
- (IBAction)backSpaceAction:(UIButton *)sender;

- (IBAction)submitInfoAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *surePassword;
@property (weak, nonatomic) IBOutlet UITextField *typeField;

/*---------------------------------------------------------*/
@property (nonatomic, assign) BOOL isGoFroward;

@end

@implementation MRegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self filedType];
    
    [self refreshUI];
    
    
    [[self.callBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"---返回---");
    }];
    
    
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self goForwardAnimation];
        NSLog(@"---submitBtn点击---");
    }];
    
//    
    
//    [_nameField.rac_textSignal  subscribeNext:^(id x) {
//        
//     
//        NSLog(@"--------%@---",  NSStringFromClass([x class]));
//        
//    }];
//
//    [RACObserve(self, nameField) subscribeNext:^(id x) {
//        NSLog(@"------RACObserve = %@----", x);
//    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//刷新UI
- (void)refreshUI
{
        _secondBackView.hidden = !_isGoFroward;
        _firstBackView.hidden = _isGoFroward;
}

//前进动画
- (void)goForwardAnimation
{
    
    _isGoFroward = YES;
    [self refreshUI];

    [UIView transitionWithView:self.view duration:2 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCurlUp  animations:nil completion:^(BOOL finished) {
    }];
}


//后退动画
- (void)backSpaceAnimation
{
    
    _isGoFroward = NO;
    [self refreshUI];

    [UIView transitionWithView:self.view duration:2 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCurlDown animations:nil completion:^(BOOL finished) {
    }];

}

//检查资料是否完善
- (void)checkFiledText
{

    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:self.nameField];
        [subscriber sendNext:self.phoneField];
        [subscriber sendNext:self.adressField];
        [subscriber sendNext:self.emailField];
        [subscriber sendNext:self.emailField];
        [subscriber sendNext:self.emailField];
        [subscriber sendNext:self.emailField];
        [subscriber sendNext:self.emailField];
        return nil;
    }];
    
    
    [signal subscribeNext:^(id x) {
        NSLog(@"----%@-----", x);
    }];

}

//设置textFild样式
- (void)filedType
{
    _nameField.layer.borderWidth = 1;
    _nameField.layer.cornerRadius = 1;
    _nameField.layer.borderColor = [UIColor yellowColor].CGColor;
    
    _phoneField.layer.borderWidth = 1;
    _phoneField.layer.cornerRadius = 1;
    _phoneField.layer.borderColor = [UIColor yellowColor].CGColor;

    _adressField.layer.borderWidth = 1;
    _adressField.layer.cornerRadius = 1;
    _adressField.layer.borderColor = [UIColor yellowColor].CGColor;

    _emailField.layer.borderWidth = 1;
    _emailField.layer.cornerRadius = 1;
    _emailField.layer.borderColor = [UIColor yellowColor].CGColor;

    _accountField.layer.borderWidth = 1;
    _accountField.layer.cornerRadius = 1;
    _accountField.layer.borderColor = [UIColor yellowColor].CGColor;

    _passwordField.layer.borderWidth = 1;
    _passwordField.layer.cornerRadius = 1;
    _passwordField.layer.borderColor = [UIColor yellowColor].CGColor;

    _surePassword.layer.borderWidth = 1;
    _surePassword.layer.cornerRadius = 1;
    _surePassword.layer.borderColor = [UIColor yellowColor].CGColor;

    _typeField.layer.borderWidth = 1;
    _typeField.layer.cornerRadius = 1;
    _typeField.layer.borderColor = [UIColor yellowColor].CGColor;

}

- (IBAction)backSpaceAction:(UIButton *)sender {
    [self backSpaceAnimation];
}

- (IBAction)submitInfoAction:(UIButton *)sender {
    NSLog(@"------提交信息-------");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
