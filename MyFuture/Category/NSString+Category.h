//
//  NSString+Category.h
//  ChuanZhiTest
//
//  Created by 李宏鑫 on 16/3/3.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

//test测试
+ (void)callBack:(void(^)(NSString *str))myBack;

//手机号验证
//- (BOOL)validateMobile:(NSString *)mobileNum;

//邮箱验证
+ (BOOL) validateEmail:(NSString *)email;

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile;

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;

//车型
+ (BOOL) validateCarType:(NSString *)CarType;

//用户名
+ (BOOL) validateUserName:(NSString *)name;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//返回文本高度
- (CGSize)sizeForText;

@end
