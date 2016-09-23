//
//  MLogoutViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/7.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MLogoutViewController.h"
#import "RESideMenu.h"
#import "MUserManger.h"
#import "MMusic.h"

#define Cell_Indetifi  @"cellIndetifi"

@interface MLogoutViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation MLogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setAppearance];
    
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ----setter
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 375, 500) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Cell_Indetifi];
//        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//
//        _tableView.sectionHeaderHeight = 5;
        
        _tableView.backgroundColor = [UIColor clearColor];

    }
    return _tableView;
}

- (void)setAppearance
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars@2x.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IconHome@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];

     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Stars@2x"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    
    [btn setBackgroundColor:[UIColor redColor]];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [MUserManger userLogout];
        [[NSNotificationCenter defaultCenter] postNotificationName:MUSICNOTFIKEY object:nil];
        
         }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@-20);
        make.height.equalTo(@30);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [(@[@[@"夜间模式",@"地理位置"],
                        @[@"精彩内容",@"清除缓存"],
                          @[@"用户使用协议",@"当前版本好"]]) mutableCopy];
        
    }
    return _dataSource;
}


#pragma mark ----dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_Indetifi];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;

}

#pragma mark ----delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
