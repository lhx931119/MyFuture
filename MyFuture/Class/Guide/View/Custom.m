//
//  Custom.m
//  ReuseView
//
//  Created by mywl-ios2 on 15/7/2.
//  Copyright (c) 2015年 mywl-ios2. All rights reserved.
//

#import "Custom.h"
#import "CustomBtn.h"
#import "UIImageView+AFNetworking.h"
@interface Custom ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CustomBtn *regis;
@property (nonatomic, strong) CustomBtn *login;
@property (nonatomic, assign) BOOL isGuide;
@end

@implementation Custom

- (instancetype)initWithFrame:(CGRect)frame isGuide:(BOOL)isguide
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isGuide = isguide;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}


- (void)autoStartView:(BOOL)autoStart
{
    // 定时器 循环
    if (autoStart) {
        
        if (!_timer) {
            _timer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        }
    }
}

- (void)stopTimer
{
    [_timer setFireDate:[NSDate distantFuture]];
}


- (void)startTimer
{
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
#pragma mark-懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addViewOnScrollView:_scrollView];
    }
    return _scrollView;
}


- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.01, self.frame.size.height * 0.8, self.frame.size.width - 2 * _pageControl.frame.origin.x, 30)];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor blackColor]];
        _pageControl.numberOfPages = [self.slideImages count];
        _pageControl.currentPage = 0;
        // 触摸mypagecontrol触发change这个方法事件
        [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
- (NSMutableArray *)slideImages
{
    if (!_slideImages) {
        self.slideImages = [(@[@"ruiwen.jpg", @"liulang.jpg", @"sunwukong.jpg", @"manwang.jpg"]) copy];
    }
    return _slideImages;
}

- (CustomBtn *)regis
{
    if (!_regis) {
        _regis = [[CustomBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 30) FromColorArray:[(@[[UIColor blueColor], [UIColor purpleColor]]) mutableCopy] ByBtnTyple:upleftTolowRight];
        _regis.tag = 1000;
        [_regis setTitle:@"注册" forState:UIControlStateNormal];
        [_regis addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _regis;
}

- (CustomBtn *)login
{
    if (!_login) {
        _login = [[CustomBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 30) FromColorArray:[(@[[UIColor blueColor], [UIColor purpleColor]]) mutableCopy] ByBtnTyple:upleftTolowRight];
        _login.tag = 1001;
        [_login setTitle:@"登录" forState:UIControlStateNormal];
        [_login addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _login;
}

#pragma mark 添加视图
- (void)addViewOnScrollView:(UIScrollView *)view
{
    for (int i = 0; i < [self.slideImages count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake(self.frame.size.width * (i + 1), 0, self.frame.size.width, self.frame.size.height);
        if (i == 3) {
            if (_isGuide) {
                [imageView addSubview:self.regis];
                [imageView addSubview:self.login];
                imageView.userInteractionEnabled = YES;
                [_regis mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(@-50);
                    make.left.equalTo(@60);
                }];
                
                [_login mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(@-50);
                    make.right.equalTo(@-60);
                }];
            }
        }
        // 首页是第0页,默认从第1页开始的。
        [view addSubview:imageView];
    }
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:([_slideImages count] -1)]]];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height); //添加最后1页在首页循环
    [view addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((self.frame.size.width * ([_slideImages count] + 1)) , 0, self.frame.size.width, self.frame.size.height); // 添加第1页在最后 循环
    [view addSubview:imageView];
    
    [view setContentSize:CGSizeMake(self.frame.size.width * ([_slideImages count] + 2), self.frame.size.height)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [view setContentOffset:CGPointMake(0, 0)];
    [view scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
}

#pragma mark pagecontrol 选择器的方法
- (void)turnPage
{
    NSInteger page = _pageControl.currentPage; // 获取当前的page
    // 触摸pagecontroller那个点 往后翻一页
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * (page + 1), 0, self.frame.size.width, self.frame.size.height) animated:NO];
}

#pragma mark NStimer 定时器 绑定的方法
- (void)runTimePage
{
    // 获取当前的page
    NSInteger page = _pageControl.currentPage;
    page++;
    page = page > 3 ? 0 : page;
    _pageControl.currentPage = page;
    [self turnPage];
}

#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = sender.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth / ([_slideImages count] + 2)) /pagewidth) + 1;
    page --;  // 默认从第二页开始
    _pageControl.currentPage = page;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth / ([_slideImages count] + 2)) / pagewidth) + 1;
    if (currentPage == 0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * [_slideImages count], 0, self.frame.size.width, self.frame.size.height) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage == ([_slideImages count] + 1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO]; // 最后+1,循环第1页
    }
    

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if (!_timer) {
//        [_timer finalize];
//    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

//    if (!_timer) {
//        [_timer fire];
//    }

}

@end
