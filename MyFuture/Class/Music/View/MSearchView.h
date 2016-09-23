//
//  MSearchView.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/16.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSearchView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UIButton *searcBtn;
@property (nonatomic, strong) UIView *separteView;

@property (nonatomic, copy) void(^zuijinBlock)();
@property (nonatomic, copy) void(^sousuoBlock)(NSString *str);
@end
