//
//  Custom.h
//  ReuseView
//
//  Created by mywl-ios2 on 15/7/2.
//  Copyright (c) 2015年 mywl-ios2. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomBtn;
@interface Custom : UIView<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *slideImages;
@property (strong,nonatomic) UIPageControl *pageControl;


//方法 是否自动轮播
- (void)autoStartView:(BOOL)autoStart;

- (void)btnAction:(UIButton *)sender;

- (void)stopTimer;

- (void)startTimer;

- (instancetype)initWithFrame:(CGRect)frame isGuide:(BOOL)isguide;
@end
