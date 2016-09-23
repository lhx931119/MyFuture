//
//  MRegisModel.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MRegisModel.h"
#define TypeNumber  @"cell_number"
#define TypeText    @"cell_text"
#define TypeDate    @"cell_date"
#define TypeSelect  @"cell_select"

@implementation MRegisModel


- (instancetype)initWith:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        _title = dic[@"value"];
        _require = [dic[@"require"] boolValue];
        _memberType = dic[@"memberType"];
        _isShow = [dic[@"isShow"] boolValue];
        _isOlder = YES;
        NSString *type = dic[@"type"];
        if ([type isEqualToString:TypeNumber]) {
            _type = AttributeValueTypeNumber;
        }else if ([type isEqualToString:TypeDate]){
            _type = AttributeValueTypeDate;
        }else if ([type isEqualToString:TypeText]){
            _type = AttributeValueTypeText;
        }else{
            _type = AttributeValueTypeSelect;
        }
    }
    return self;
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    NSLog(@"----%@-----", key);
//}
@end
