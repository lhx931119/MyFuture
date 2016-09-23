//
//  TripsTableViewCell.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/8/1.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MShareView;


//测试枚举
typedef NS_ENUM(NSInteger, cellType)
{
    text = 0,
    video,
    message,
    
};


typedef void(^ShareBlock)();

@interface TripsTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary *dic;

@property (nonatomic, copy)  ShareBlock block;

@property (nonatomic, assign) cellType type; //cell类型

@property (nonatomic, strong) MShareView *shareView;

+ (CGFloat)rowHeightWithDic:(NSDictionary *)dic;


@end
