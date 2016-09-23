//
//  MGuideView.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/7.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MGuideView.h"
#import "CustomBtn.h"

@interface MGuideView ()<UIScrollViewDelegate>
@property (nonatomic, strong) CustomBtn *regis;
@property (nonatomic, strong) CustomBtn *login;

@end

@implementation MGuideView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark ---setter 

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * 4, 0);
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
- (void)addViewOnScrollView:(UIScrollView *)view
{
    for (int i = 0; i < [self.slideImages count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        if (i == 3) {
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
        // 首页是第0页,默认从第1页开始的。
        [view addSubview:imageView];
    }
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

- (NSMutableArray *)slideImages
{
    if (!_slideImages) {
        self.slideImages = [(@[@"ruiwen.jpg", @"liulang.jpg", @"sunwukong.jpg", @"manwang.jpg"]) copy];
    }
    return _slideImages;
}

#pragma mark pagecontrol 选择器的方法
- (void)turnPage
{
    NSInteger page = _pageControl.currentPage; // 获取当前的page
    // 触摸pagecontroller那个点 往后翻一页
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * (page + 1), 0, self.frame.size.width, self.frame.size.height) animated:NO];
}


#pragma mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = sender.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth / ([_slideImages count]) + 2) /pagewidth) + 1;
//    page --;  // 默认从第二页开始
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
//    else if (currentPage == ([_slideImages count] + 1))
//    {
//        [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO]; // 最后+1,循环第1页
//    }
}

- (void)btnAction:(UIButton *)sender
{
    NSLog(@"-----按钮被点击------");
}
    @end
