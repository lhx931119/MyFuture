//
//  CustomBtn.h
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BtnTyple)
{
    topToBottom = 0,
    leftToRight,
    upleftTolowRight,
    uprightTolowLeft
};

@interface CustomBtn : UIButton


- (id)initWithFrame:(CGRect)frame FromColorArray:(NSMutableArray *)colorArray ByBtnTyple:(BtnTyple)typle;


- (instancetype)initFromColorArray:(NSMutableArray *)colorArray ByBtnTyple:(BtnTyple)typle;
@end
