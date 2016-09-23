//
//  MRegisTableViewCell.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MRegisModel;

@interface MRegisTableViewCell : UITableViewCell

@property (nonatomic, strong) MRegisModel *model;

@property (nonatomic, copy) void(^FinishSelect)(NSString *str);//完成选择

+ (MRegisTableViewCell *)cellCreatWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;@end
