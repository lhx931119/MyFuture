//
//  MMoivePlayViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/21.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MMoviePlayViewController.h"
#import "MWaitAnimation.h"


@interface MMoviePlayViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *message;

@end

@implementation MMoviePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.message = @"网络不给力，请稍后再试！";
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    NSURL *url = [NSURL URLWithString:_path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    [MWaitAnimation popuMessage:@"正在加载中......."];
    [self performSelector:@selector(loadWaiting) withObject:nil afterDelay:10.0];
}

- (void)loadWaiting
{
    [_webView stopLoading];
    [MWaitAnimation popuTitle:self.message];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.message = @"网络不给力，请稍后再试！";
        [MWaitAnimation dissmissAnimation:YES];
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --webViewDelegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteURL);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MWaitAnimation dissmissAnimation:YES];
    NSLog(@"webViewDidFinishLoad");

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    self.message = @"资源错误！";
    NSLog(@"didFailLoadWithError");

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
