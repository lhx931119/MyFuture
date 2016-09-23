//
//  MMoviewHeadView.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/3/20.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMoviewHeadView.h"

@interface MMoviewHeadView ()<UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *slideImages;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) NSTimer *timer;

@end

@implementation MMoviewHeadView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)autoStartView:(BOOL)autoStart
{
    // 定时器 循环
    if (autoStart) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    }
}

#pragma mark-懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
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
        self.slideImages = [(@[@"anni.jpg", @"hanbing.jpg", @"manwang.jpg", @"xiezi.jpg"]) copy];
    }
    return _slideImages;
}

#pragma mark 添加视图
- (void)addViewOnScrollView:(UIScrollView *)view
{
    for (int i = 0; i < [self.slideImages count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake(self.frame.size.width * (i + 1), 0, self.frame.size.width, self.frame.size.height);
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



@end
