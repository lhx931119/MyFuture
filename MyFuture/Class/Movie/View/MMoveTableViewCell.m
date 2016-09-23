//
//  MMoveTableViewCell.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/15.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMoveTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MMoveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic
{
    _icn.image = nil;
    NSURL *path = [NSURL URLWithString:dic[@"icn"]];
    [_icn sd_setImageWithURL:path];
    _name.text = dic[@"title"];
    _favort.text = dic[@"name"];
}
@end
