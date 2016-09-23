//
//  TripsTableViewCell.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/8/1.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "TripsTableViewCell.h"
#import "MShareView.h"
#import "WXApiObject.h"
#import "WXApi.h"


@interface TripsTableViewCell ()

@property (nonatomic, strong) UILabel *introduce; //内容
@property (nonatomic, strong) UILabel *nameLabel; //标题
@property (nonatomic, strong) UIImageView *icn; //图标

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;  //长按手势
@end

@implementation TripsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return  self;
}

- (void)setUI
{
    
    _icn = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    _icn.backgroundColor = [UIColor cyanColor];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 15, 100, 20)];
    _nameLabel.font =  [UIFont systemFontOfSize:15];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    _introduce = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 30)];
    _introduce.font = [UIFont systemFontOfSize:12.0];
    _introduce.numberOfLines = 10;
    
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(share:)];
    
    [self.contentView addGestureRecognizer:_longPress];
    [self.contentView addSubview:_icn];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_introduce];
}

- (void)setDic:(NSMutableDictionary *)dic
{
    _dic = dic;
    _nameLabel.text = dic[@"name"];
    _introduce.text = dic[@"content"];
    
    if ([dic[@"type"] isEqualToString:@"text"]) {
        _type = text;
    }
    
    CGRect frame = _introduce.frame;
    CGSize size = [_introduce.text sizeForText];
    frame.size = size;
    _introduce.frame = frame;
    
}

+ (CGFloat)rowHeightWithDic:(NSDictionary *)dic
{
    CGSize size = [dic[@"content"] sizeForText];
    CGFloat height = size.height;
    return 60 + height;
}


- (void)share:(UILongPressGestureRecognizer *)sender
{
    
   
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.shareView.backView.frame;
            CGPoint point = CGPointMake(0, 300);
            frame.origin = point;
            self.shareView.backView.frame = frame;
        }];
//        if (_block) {
//            _block();
//        }else{
//            ALERT(@"警示", @"无目标动作机制");
//        }
        
    }
}

- (MShareView *)shareView
{
    if (!_shareView) {
        _shareView = [[MShareView alloc] initWithFrame:CGRectMake(0, 0, 375, 600) shareBlock:^{
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.text = self.introduce.text;
            req.bText = YES;
            req.scene = self.type;
            [WXApi sendReq:req];
                   }];
    }
    return _shareView;
}
@end
