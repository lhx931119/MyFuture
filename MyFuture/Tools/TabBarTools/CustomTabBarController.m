//
//  CustomTabBarController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/1/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "CustomTabBarController.h"
#import "TabBarView.h"
#import "DiscoverViewController.h"
#import "ExploreViewController.h"
#import "TripsViewController.h"
#import "MeViewController.h"
#import "FileManger.h"
#import "RESideMenu.h"
#import "MMusic.h"
#import "MUserManger.h"


@interface CustomTabBarController ()
@property (nonatomic, strong) UIViewController *currentController;

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat orginHeight = self.view.frame.size.height- 60;

    _tabbar = [[TabBarView alloc] initWithFrame:CGRectMake(0, orginHeight, self.view.frame.size.width, 60)];
    _viewControllers = [self getViewcontrollers];
    
    [self touchBtnAtIndex:[MUserManger shareInstance].index];
    __weak typeof(self) weakSelf = self;
    _tabbar.touchBtnBlock = ^(NSInteger index){
        _selectIndex = index;
        [MUserManger shareInstance].index = index;
        
        [weakSelf touchBtnAtIndex:index];
    };
    

    _tabbar.touchCenterBtnBlock = ^(){
        NSLog(@"------中间按钮被点击---------");
        if ([weakSelf.currentController isKindOfClass:[ExploreViewController class]]) {
            ExploreViewController *explore = (ExploreViewController *)weakSelf.currentController;
            if (explore.musicStart) {
                explore.musicStart();
            }
        }
    };
    
    [self.view addSubview:_tabbar];
    [self setNavBarAppearance];
    
}

- (void)setNavBarAppearance
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Stars@2x"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [UIImage imageNamed:@"IconProfile@2x.png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
    [MUserManger shareInstance].controller = self;
}


- (void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    _tabbar.tabbarView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%ld", _selectIndex]];
    
    NSDictionary* data = [_viewControllers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    _currentController = viewController;
    [self.view insertSubview:viewController.view belowSubview:_tabbar
     ];
    
}

- (NSMutableArray *)getViewcontrollers
{
    NSMutableArray* tabBarItems = nil;
    
     DiscoverViewController *discover = [[DiscoverViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discover];
    
    ExploreViewController *explore = [[ExploreViewController alloc] init];
    UINavigationController *exploreNav = [[UINavigationController alloc] initWithRootViewController:explore];

    
    TripsViewController *trip = [[TripsViewController alloc] init];
    UINavigationController *tripNav = [[UINavigationController alloc] initWithRootViewController:trip];

    MeViewController *me = [[MeViewController alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:me];

    
    tabBarItems = [([NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", discoverNav, @"viewController",@"discover",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", exploreNav, @"viewController",@"explore",@"title", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", tripNav, @"viewController",@"trip",@"title", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", meNav, @"viewController",@"me",@"title", nil],
                     nil]) mutableCopy];
    return tabBarItems;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
