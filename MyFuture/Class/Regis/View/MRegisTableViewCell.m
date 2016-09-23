//
//  MRegisTableViewCell.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/5.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MRegisTableViewCell.h"
#import "MRegisModel.h"
static NSString *cellWithIdentifier = @"CustomCell";

@interface MRegisTableViewCell ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) UIDatePicker *datePickView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) NSString *currentStr;
@property (nonatomic, strong) NSArray *dataSource;
@end


@implementation MRegisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//默认初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

//setUI
- (void)setUI
{
    
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 150)];
    self.finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishBtn.frame = CGRectMake(270, 0, 50, 30);
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.finishBtn.titleLabel.textColor = [UIColor blueColor];
    [self.finishBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(0, 0, 50, 30);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.textColor = [UIColor blueColor];
    [self.cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _backView.backgroundColor = [UIColor grayColor];
    [self addSubview:_backView];
    [_backView addSubview:_finishBtn];
    [_backView addSubview:_cancelBtn];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//按钮点击方法
- (void)btnAction:(UIButton *)sender
{
    if (sender == _cancelBtn) {
        _currentStr = @"";
    }
    _FinishSelect(_currentStr);
}

///返回cell高度
+ (CGFloat)cellHeight
{
    return 150;
}

//cell创建方法
+ (MRegisTableViewCell *)cellCreatWithTableView:(UITableView *)tableView
{
    [tableView registerClass:[self class] forCellReuseIdentifier:cellWithIdentifier];
    MRegisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithIdentifier];
    return cell;
}

//setter -- dataSource

- (void)setModel:(MRegisModel *)model
{
    _model = model;
    _dataSource = [model.memberType componentsSeparatedByString:@","];
    [self addView];
}

//getter方法
- (UIPickerView *)pickView
{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 375, self.backView.frame.size.height - 30)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UIDatePicker *)datePickView
{
    if (!_datePickView) {
        _datePickView.date = [NSDate date];
        _datePickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, 375, self.backView.frame.size.height - 30)];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        _currentStr = [formatter stringFromDate:date];
        _datePickView.datePickerMode = UIDatePickerModeDate;
        [_datePickView addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePickView;
}
//初始页面布局
- (void)addView
{
    
    if (_model.type == AttributeValueTypeSelect) {
        
        [self addTextPickViewOnCell];
        
    }else if (_model.type == AttributeValueTypeDate)
    {
         [self addDatePickViewOnCell];
    }

}


- (void)addTextPickViewOnCell
{
    if (_datePickView) {
        _datePickView.hidden = YES;
    }
    
    if (_pickView.hidden) {
        _pickView.hidden = NO;
        [_pickView reloadAllComponents];
        return;
    }
    
    if (!_pickView) {
        [self addSubview:self.pickView];
        return;
    }
    [_pickView reloadAllComponents];

}

- (void)addDatePickViewOnCell
{
    if (_pickView) {
        _pickView.hidden = YES;
    }
    
    if (_datePickView.hidden) {
        _datePickView.hidden = NO;
        return;
    }
    
    if (!_datePickView) {
        [self addSubview:self.datePickView];
        return;
    }
  
}

//datePick数值变化方法
- (void)valueChanged:(UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    _currentStr = [formatter stringFromDate:sender.date];
}

#pragma mark -pickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSLog(@"----------NSString = %@-----", _dataSource[row]);

    self.currentStr = _dataSource[row];
    return _dataSource[row];
}

#pragma mark -pickViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    NSLog(@"----------NSInteger = %ld-----", _dataSource.count);

    return [_dataSource count];
}


@end
