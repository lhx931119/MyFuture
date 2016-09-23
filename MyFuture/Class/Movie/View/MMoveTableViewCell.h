//
//  MMoveTableViewCell.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/15.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMoveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icn;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *favort;

@property (nonatomic, strong) NSDictionary *dic;
@end
