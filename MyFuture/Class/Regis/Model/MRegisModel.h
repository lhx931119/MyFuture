//
//  MRegisModel.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AttributeValueType)
{
    AttributeValueTypeText = 0, // 文本
    AttributeValueTypeNumber,   // 数字
    AttributeValueTypeDate,     // 日期
    AttributeValueTypeSelect   // 单选
};

@interface MRegisModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *memberType;
@property (nonatomic, assign) BOOL require;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isOlder;
@property (nonatomic, assign) AttributeValueType type;
@property (nonatomic, copy) NSString *value;

- (instancetype)initWith:(NSDictionary *)dic;

@end
