//
//  MMPictureCollectionViewCell.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/22.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMPictureCollectionViewCell.h"

@implementation MMPictureCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 75, 75);
}
@end
