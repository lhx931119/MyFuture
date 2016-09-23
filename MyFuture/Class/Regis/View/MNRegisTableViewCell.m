//
//  MNRegisTableViewCell.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MNRegisTableViewCell.h"
#import "MRegisModel.h"
#import "NSString+Category.h"
@interface MNRegisTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *requireLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) MRegisModel *model;


@end

@implementation MNRegisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self addSeparatorWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 0.5)];
    
    self.textField.layer.cornerRadius = 5;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [UIColor blackColor].CGColor;
    // Initialization code
}

- (void)addSeparatorWithFrame:(CGRect)frame {
//    CALayer* separator = [CALayer layer];
//    separator.frame = frame;
//    separator.backgroundColor = RGB(200, 199, 204).CGColor;
//    [self.layer addSublayer:separator];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)creatCellForModel:(MRegisModel *)model indexPath:(NSIndexPath *)indexPath
{
    
    self.model = model;
    self.textField.text = model.value;
    _valueLabel.text = model.title;
    _requireLabel.hidden = !model.require;
    _textField.delegate = self;
    
    switch (model.type) {
        case AttributeValueTypeNumber:
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.enabled = YES;
            break;
            
        case AttributeValueTypeText:
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.enabled = YES;
            break;

        case AttributeValueTypeDate:
            self.textField.enabled = NO;
            break;

        case AttributeValueTypeSelect:
            self.textField.enabled = NO;
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        NSString *str = x;
        self.model.value = str;
        if ([self.model.title isEqualToString:@"电话号码"]) {
            BOOL result = [NSString validateMobile:x];
            if (!result) {
                self.textField.layer.borderColor = [UIColor redColor].CGColor;
            }else{
                self.textField.layer.borderColor = [UIColor blackColor].CGColor;
            }
        }else if ([self.model.title isEqualToString:@"密码"]) {
            if (str.length < 7) {
                self.textField.layer.borderColor = [UIColor redColor].CGColor;
            }else{
                self.textField.layer.borderColor = [UIColor blackColor].CGColor;
            }
        }else{
            
            self.textField.layer.borderColor = [UIColor blackColor].CGColor;
            }
    }];

    return YES;
}

@end
