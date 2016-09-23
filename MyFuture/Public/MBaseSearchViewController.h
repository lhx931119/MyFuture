//
//  MBaseSearchViewController.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/16.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBaseSearchViewController : UITableViewController
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, copy) void(^timerStartBloack)();
@property (nonatomic, copy) void(^musicStartBlock)(NSString *address);
@end
