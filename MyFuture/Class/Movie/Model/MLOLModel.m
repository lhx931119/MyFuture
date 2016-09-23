//
//  MLOLModel.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/11.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MLOLModel.h"

@implementation MLOLModel


- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _name = dic[@"name"];
        _sex = dic[@"sex"];
        _panter = dic[@"panter"];
        _icn = dic[@"icn"];
        _info = dic[@"info"];
        _favort = dic[@"favort"];
        _title = dic[@"title"];
        _address = dic[@"address"];
    }
    return self;
}
@end
