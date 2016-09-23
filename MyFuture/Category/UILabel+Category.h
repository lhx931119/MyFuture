//
//  UILabel+Category.h
//  ChuanZhiTest
//
//  Created by 李宏鑫 on 16/3/3.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UILabel (Category)


//所要修改的字符串属性（字符串内容，字体颜色，字体大小）
- (void)text:(NSString *)str color:(UIColor *)color font:(UIFont *)font;


//修改所需要调用的方法
- (void)changeColor;



@end
