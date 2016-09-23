//
//  MNewRegisViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MNewRegisViewController.h"
#import "MNRegisTableViewCell.h"
#import "MRegisTableViewCell.h"
#import "MRegisModel.h"
#import "MRegisHeadView.h"
#import "MWaitAnimation.h"
#import "MSqiteManger.h"
#import "MXAlertView.h"
#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "MUserManger.h"

#define CellIndetifi @"cellindetifi"
#define New_CellIndetifi @"new_cellIndetifi"
@interface MNewRegisViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *expandAry;
@property (nonatomic, strong) MRegisHeadView *headView;
@property (nonatomic, strong) NSMutableDictionary *dicInfo;

- (IBAction)regisAction:(UIButton *)sender;

@end

@implementation MNewRegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MNRegisTableViewCell" bundle:nil] forCellReuseIdentifier:CellIndetifi];
    
    
     [self.tableView registerClass:[MRegisTableViewCell class] forCellReuseIdentifier:New_CellIndetifi];

    [self.view addSubview:self.headView];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----setter
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MRegisInfo.plist" ofType:nil];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *array = dic[@"RegisInfo"];
        _dataSource = [[[array.rac_sequence map:^id(id value) {
            return [[MRegisModel alloc] initWith:value];
        }] array] mutableCopy];
    }
    return _dataSource;
}

- (MRegisHeadView *)headView
{
    __weak typeof(self) weakSlef = self;
    if (!_headView) {
        _headView = [[MRegisHeadView alloc] initWithFrame:CGRectMake(0, 0, 375, 70) btn:_isHiddle callBack:^{
            [weakSlef.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _headView;
}

- (NSMutableDictionary *)dicInfo
{
    if (!_dicInfo) {
        _dicInfo = [NSMutableDictionary dictionary];
    }
    return _dicInfo;
}
#pragma mark ------dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


#pragma mark -----delegate


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MRegisModel *model = self.dataSource[indexPath.row];
    MNRegisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifi];
    if (model.isShow && model.isSelect && !model.isOlder) {
        MRegisTableViewCell *regisCell = [tableView dequeueReusableCellWithIdentifier:New_CellIndetifi];
        regisCell.model = model;
        NSLog(@"-----%@-----", regisCell.model.memberType);
        __weak typeof(self) weakSelf = self;
        regisCell.FinishSelect = ^(NSString *str)
        {
            MRegisModel *newModel = weakSelf.dataSource[indexPath.row - 1];
            if ([str isEqualToString:@""]) {
                
            }else{
                newModel.value = str;
            }
            newModel.isSelect = NO;
            [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
        };
        return regisCell;
    }else{
        [cell creatCellForModel:model indexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL result = [[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[MRegisTableViewCell class]];
    if (result) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"-----无法执行该动作----");
        return;
    }
    
    MRegisModel *model = self.dataSource[indexPath.row];
    if ([model.memberType isEqualToString:@""]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"-----无法执行该动作----");
        return;
    }
    
    if (!model.isSelect && model.isShow) {
        MRegisModel *newModel = [[MRegisModel alloc] init];
        newModel.memberType = model.memberType;
        newModel.isSelect = YES;
        newModel.isShow = YES;
        newModel.isOlder = NO;
        newModel.type = model.type;
        model.isSelect = YES;
        [self.dataSource insertObject:newModel atIndex:indexPath.row + 1];
    }else if (model.isSelect && model.isShow)
    {
        model.isSelect = NO;
        [self.dataSource removeObjectAtIndex:indexPath.row + 1];
    }
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MRegisModel *model = self.dataSource[indexPath.row];
    if (model.isShow && model.isSelect && !model.isOlder) {
        return [MRegisTableViewCell cellHeight];
    }
    return 70;
}

#pragma mark ---privte

- (BOOL)checkInfo
{
    
    for (MRegisModel *model in self.dataSource) {
        if (model.value.length == 0 &&  model.require) {
            ALERT(@"", @"*号内容不能为空");
            return NO;
        }
        if (!model.value) {
            model.value = @"";
        }
        [self.dicInfo setObject:model.value forKey:model.title];
    }
    
    return YES;
}

//注册按钮点击
- (IBAction)regisAction:(UIButton *)sender {
    
    
   BOOL result =  [self checkInfo];
    if (!result) {
        return;
    }
    
    [MWaitAnimation popuMessage:@"请稍等....."];
/********************数据库操作以及动画提示******************************/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDateFormatter *formatter = [NSDateFormatter defaultDateFormatter];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        NSArray *values = @[self.dicInfo[@"会员类型"],
                            self.dicInfo[@"出生年月"],
                            self.dicInfo[@"密码"],
                            self.dicInfo[@"性别"],
                            self.dicInfo[@"拓展属性"],
                            self.dicInfo[@"爱好"],
                            self.dicInfo[@"电话号码"],
                            self.dicInfo[@"登录帐号"],
                            dateStr,
                            ];
        
        NSArray *keys = @[mUserInformationTable_memberType,       mUserInformationTable_years, mUserInformationTable_passWord, mUserInformationTable_sex, mUserInformationTable_expandMemberType,
                          mUserInformationTable_favort,
                          mUserInformationTable_userCount,
                          mUserInformationTable_connectCount,
                          mUserInformationTable_date];
        
        MSqiteManger *manger = [MSqiteManger shareMSqliteManger];
        NSString *where = [NSString stringWithFormat:@"%@ = %@", mUserInformationTable_userCount, self.dicInfo[@"电话号码"]];
        int rowCount = [manger rowCount:mUserInformationTable where:where];
        
        
        if (rowCount > 0) {
            [MWaitAnimation dissmissAnimation:YES];
            MXAlertView *alertView = [[MXAlertView alloc] initWithMessage:@"账号已存在！" statue:MXAlert_failure signle:YES arg:@[@"确认"]];
            __weak typeof(MXAlertView) *weakAlert = alertView;
            alertView.signleBlock = ^(){
                [weakAlert disMissAnimation:YES];
            };
            [alertView showWarm];
            
        }else if (rowCount == 0){
            BOOL result = [manger insert:mUserInformationTable insertKey:keys insertValue:values];
            if (!result) {
                [MWaitAnimation dissmissAnimation:YES];
                ALERT(@"", @"数据库异常！");
                return;
            }
            
            [MWaitAnimation dissmissAnimation:YES];
            MXAlertView *alertView = [[MXAlertView alloc] initWithMessage:@"注册成功！" statue:MXAlert_success signle:YES arg:@[@"确认"]];
            __weak typeof(MXAlertView) *weakAlert = alertView;
            alertView.signleBlock = ^(){
                [weakAlert disMissAnimation:YES];
                
                NSDictionary *dic = @{@"key":self.dicInfo[@"电话号码"],
                                      @"value":self.dicInfo[@"密码"]};
                UserDefaultWrite(MUserInfo, dic);
                UserDefaultSynchronize;
                [MUserManger userLogin];
            };
            [alertView showWarm];
        }
    });

}


@end

