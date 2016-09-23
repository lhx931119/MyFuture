//
//  MLOLModel.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/11.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLOLModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icn;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *panter;
@property (copy, nonatomic) NSString *info;
@property (copy, nonatomic) NSString *favort;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *title;

- (instancetype)initWithDic:(NSDictionary *)dic;
@end
