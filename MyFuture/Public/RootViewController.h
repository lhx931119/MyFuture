//
//  RootViewController.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, strong) void(^pushBlock)(NSString *str);
@property (nonatomic, strong) void(^hiddleBlock)(BOOL isHidden);

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITextField *normalField;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;


- (void)btnAction:(UIButton *)sender;

@end
