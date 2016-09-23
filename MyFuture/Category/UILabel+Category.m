//
//  UILabel+Category.m
//  ChuanZhiTest
//
//  Created by 李宏鑫 on 16/3/3.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)


- (void)text:(NSString *)str color:(UIColor *)color font:(UIFont *)font
{
    if (!str)
        
        str = self.text;
    //        str = self;
    
    if (!color)
        
        color = [UIColor redColor];
    
    if (!font)
        
        font = self.font;
    
    [self.attributeString setAttributes:@{NSForegroundColorAttributeName:color,
                                          
                                          NSFontAttributeName:font}
     
                                  range:[self.text rangeOfString:str]];
}

- (void)changeColor

{
    
    self.attributedText = self.attributeString;
    
}



- (NSMutableAttributedString *)attributeString

{
    
    NSMutableAttributedString *attributeString = objc_getAssociatedObject(self, _cmd);
    
    if (attributeString && [attributeString.string isEqualToString:self.text]) {
        
        return attributeString;
        
    }
    
    attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    objc_setAssociatedObject(self, _cmd, attributeString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return attributeString;
    
}

@end
