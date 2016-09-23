//
//  RootViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars@2x.png"]];
    
    [self.view addSubview:self.scrollView];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillShowNotification
//                                                  object:nil];

}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyBoardSize = [value CGRectValue].size;
    _keyBoardHeight = keyBoardSize.height;
    if (self.dataSource.count == 1) {
        return;
    }
    [self.scrollView addSubview:self.tableView];
    self.scrollView.scrollEnabled = NO;

}

#pragma mark ---setter 

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        NSArray *array = UserDefaultRead(@"dataSource");
        _dataSource = [NSMutableArray arrayWithArray:array];
//        _dataSource = [NSMutableArray array];
        if (_dataSource.count == 0) {
            [_dataSource addObject:@"清空搜索数据！"];
        }
    }
    return _dataSource;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
        _scrollView.contentSize = CGSizeMake(375, 668);
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:self.searchView];
    }
    return _scrollView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat temp = CGRectGetMaxY(self.searchView.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(37.5,  temp + 2, 300, 667 - temp - _keyBoardHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 3;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIndefier"];
    }
    return _tableView;
}
- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(37.5, 100, 300, 30)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.layer.cornerRadius = 3;

        
        _normalField = [[UITextField alloc] init];
        _normalField.borderStyle = UITextBorderStyleNone;
        _normalField.keyboardType = UIKeyboardTypeWebSearch;
        _normalField.delegate = self;
        
        _normalField.placeholder = @"搜索歌曲";
        _normalField.textAlignment = NSTextAlignmentCenter;
        [_searchView addSubview:_normalField];
        [_normalField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@0);
            make.width.equalTo(@300);
            make.height.equalTo(@30);
        }];

        
        _searchBtn = [[UIButton alloc] init];
        [_searchView addSubview:_searchBtn];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"icon_search@2x.png"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.top.equalTo(@0);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];

//        [self.scrollView addSubview:_searchView];

    }
    return _searchView;
}

#pragma mark ---btnACtion

- (void)btnAction:(UIButton *)sender;
{
    BOOL result = [sender.currentBackgroundImage isEqual:[UIImage imageNamed:@"icon_search@2x.png"]];
    if (!result) {
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"icon_search@2x.png"] forState:UIControlStateNormal
         ];
        
        if (self.normalField.text.length != 0 && ![self.dataSource containsObject:self.normalField.text]) {
            [self.dataSource insertObject:self.normalField.text atIndex:0];
            UserDefaultWrite(@"dataSource", self.dataSource);
            UserDefaultSynchronize;
            _pushBlock(self.normalField.text);
        }else if (self.normalField.text.length != 0){
            _pushBlock(self.normalField.text);
        }
        self.normalField.text = @"";
        self.normalField.textAlignment = NSTextAlignmentCenter;
        self.normalField.placeholder = @"搜索歌曲";
        [self.normalField resignFirstResponder];
        [self.tableView removeFromSuperview];
        self.scrollView.scrollEnabled = YES;
        self.tableView = nil;
        _hiddleBlock(NO);
        return;
    }
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"layer-cancel-normal@2x.png"] forState:UIControlStateNormal
     ];
    _pushBlock(self.normalField.text);
}



#pragma mark ----datsSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIndefier"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    if ((indexPath.row + 1) == self.dataSource.count) {
//        cell.detailTextLabel.text = self.dataSource[indexPath.row];
//    }
    cell.textLabel.text = self.dataSource[indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

#pragma mark ---TextFieldDelegate



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;

{
    
    _hiddleBlock(YES);
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"layer-cancel-normal@2x.png"] forState:UIControlStateNormal
     ];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.placeholder = @"";
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self btnAction:self.searchBtn];

//    if (textField.text.length != 0 && ![self.dataSource containsObject:textField.text]) {
//        [self.dataSource insertObject:textField.text atIndex:0];
//        _pushBlock(textField.text);
//        [self btnAction:self.searchBtn];
//        return YES;
//    }
//    
//    textField.text = @"";
//    textField.textAlignment = NSTextAlignmentCenter;
//    textField.placeholder = @"搜索歌曲";
//    
//    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"icon_search@2x.png"] forState:UIControlStateNormal
//     ];
//    [self.tableView removeFromSuperview];
//    self.tableView = nil;
//    self.scrollView.scrollEnabled = YES;
//    _hiddleBlock(NO);
//

    return YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSLog(@"---%f----", scrollView.contentOffset.y);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"---%f----", scrollView.contentOffset.y);

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    scrollView.contentOffset = CGPointZero;
    NSLog(@"---%f----", scrollView.contentOffset.y);

}
@end
