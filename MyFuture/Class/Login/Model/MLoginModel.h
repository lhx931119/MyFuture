//
//  MLoginModel.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/6.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLoginModel : NSObject

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) BOOL isWrite;

@property (nonatomic, copy) void(^callBack)();

@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;

@property (nonatomic, strong, readonly)RACCommand *loginCommand;


@end
