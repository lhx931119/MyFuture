//
//  MMPictureAddCell.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/22.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMPictureAddCell.h"

@implementation MMPictureAddCell
{
    UIImageView *_addImageView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _addImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_addImageView];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _addImageView.frame = CGRectMake(0, 0, 75, 75);
    _addImageView.image = [UIImage imageNamed:@"添加.png"];
    
}

@end
