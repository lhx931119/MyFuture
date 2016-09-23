//
//  CustomBtn.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/18.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame FromColorArray:(NSMutableArray *)colorArray ByBtnTyple:(BtnTyple)typle
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backImage = [self buttonImageFromColors:colorArray ByBtnTyple:typle];
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)initFromColorArray:(NSMutableArray *)colorArray ByBtnTyple:(BtnTyple)typle
{
    self = [super init];
    if (self) {
        UIImage *backImage = [self buttonImageFromColors:colorArray ByBtnTyple:typle];
        [self setBackgroundImage:backImage forState:UIControlStateNormal];
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (UIImage *)buttonImageFromColors:(NSMutableArray *)colorArray ByBtnTyple:(BtnTyple)typle
{
    NSMutableArray *ary = [NSMutableArray array];
    for (UIColor *color in colorArray) {
        [ary addObject:(id)color.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colorArray lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ary, NULL);
    CGPoint start;
    CGPoint end;
    switch (typle) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, self.frame.size.height);
            break;
        case 3:
            start = CGPointMake(self.frame.size.width, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
    
}

@end
