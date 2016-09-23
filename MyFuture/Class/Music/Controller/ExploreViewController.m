//
//  ExploreViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/1/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "ExploreViewController.h"
#import "MBaseSearchViewController.h"
#import "CustomTabBarController.h"
#import "MMPictureViewController.h"
#import "MMusic.h"
#import "MSearchView.h"
#import "MUserManger.h"


#import <AVFoundation/AVFoundation.h>

@interface ExploreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *labelTableView;
@property (nonatomic, strong) MMusic *musicTool;
@property (nonatomic, strong) NSMutableArray *labelSource;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat contentOffSetY;
//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UIView *backView;
//@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars@2x.png"]];
    self.title = @"explore";
    
    
//    [self.musicTool audioPlayWithHttpAddress:@"http://music.baidutt.com/up/kwcywuca/ukssyw.mp3"];
    
//    [self.musicTool audioPlayWithFileName:@"myDream.mp3"];

    __weak typeof(self) weakSelf = self;

    self.pushBlock = ^(NSString *str){
            MBaseSearchViewController *search = [[MBaseSearchViewController alloc] init];
        search.searchStr = str;
//        开启定时器
        search.timerStartBloack = ^(){
            [weakSelf.timer setFireDate:[NSDate distantPast]];
        };
        //开始音乐播放
        search.musicStartBlock = ^(NSString *address){
            [weakSelf.searchBtn setBackgroundImage:[UIImage imageNamed:@"layer-cancel-normal@2x.png"] forState:UIControlStateNormal];
            [weakSelf btnAction:weakSelf.searchBtn];
            [weakSelf.musicTool audioPlayWithHttpAddress:address];
        };
        
        CustomTabBarController *controller = [MUserManger shareInstance].controller;
            if (controller.navigationController) {
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
                controller.navigationItem.backBarButtonItem = item;
                [controller.navigationController pushViewController:search animated:YES];
            }
};
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicStop:) name:MUSICNOTFIKEY object:nil];
    
    [self.scrollView addSubview:self.labelTableView];
    self.hiddleBlock = ^(BOOL isHidden){
        weakSelf.labelTableView.hidden = isHidden;
    };
//   
//    __weak typeof(self) weakSelf = self;
//    MSearchView *searchView = [[MSearchView alloc] initWithFrame:CGRectMake(20, 100, 335, 31)];
//    searchView.zuijinBlock = ^(){
//
//        
//    };
//    
//    searchView.sousuoBlock = ^(NSString *str){
//    
//    };
//    
//    [self.view addSubview:searchView];
//    
//    [self.musicTool audioPlayWithFileName:@"myDream.mp3"];
    
//    [self.musicTool audioPlayWithHttpAddress:@"http://music.baidutt.com/up/kwcywuca/uccywd.mp3"];

//    self.musicStart = ^(){
//        [weakSelf.musicTool playMusic];
//    };
    
//    [[NSNotificationCenter defaultCenter]]
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.musicTool stop];
    
    //暂停定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开启定时器
    [self.timer setFireDate:[NSDate distantPast]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)musicStop:(NSNotification *)notifi
{
    [self.musicTool stopMusic];
}
#pragma mark ---getter


  - (MMusic *)musicTool
{
    if (!_musicTool) {
        _musicTool = [MMusic shareInstance];
    }
    return _musicTool;
}
- (UITableView *)labelTableView
{
    if (!_labelTableView) {
        _labelTableView = [[UITableView  alloc] initWithFrame:CGRectMake(35.5, 500, 300, 30) style:UITableViewStylePlain];
        _labelTableView.rowHeight = 30;
        _labelTableView.dataSource = self;
        _labelTableView.delegate = self;
        _labelTableView.backgroundColor = [UIColor whiteColor];
        _labelTableView.layer.cornerRadius = 3;
        [_labelTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Indefi"];
    }
    return _labelTableView;
}


- (NSMutableArray *)labelSource
{
    if (!_labelSource) {
        _labelSource = [(@[@"我爱我家",@"我爸我妈",@"你爸你妈"]) mutableCopy];
    }
    return _labelSource;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(labelTableViewScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

- (void)labelTableViewScroll
{
    if (!_labelTableView.hidden) {
        if (_contentOffSetY == 90) {
            _contentOffSetY = 0;
        }
        _labelTableView.contentOffset = CGPointMake(0, _contentOffSetY);
         _contentOffSetY += 30;
        return;
    }
    
    return;
    
}
#pragma mark ---dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _labelTableView) {
        return self.labelSource.count;
    }
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _labelTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Indefi"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.labelSource[indexPath.row];
        [cell.textLabel text:[cell.textLabel.text substringWithRange:NSMakeRange(1, 2)] color:[UIColor redColor] font:[UIFont systemFontOfSize:12.0]];
        [cell.textLabel changeColor];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIndefier"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;

}

#pragma mark ---delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _labelTableView) {
        NSLog(@"------labelTableViewcell被点击-------");
        
        MMPictureViewController *pictureController = [[MMPictureViewController alloc] init];
        CustomTabBarController *controller = [MUserManger shareInstance].controller;
        if (controller.navigationController) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            controller.navigationItem.backBarButtonItem = item;
            [controller.navigationController pushViewController:pictureController animated:YES];
        }
        
        //模态
//        [self presentViewController:pictureController animated:YES completion:nil];
    }else{
        if ((indexPath.row + 1) == self.dataSource.count) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:@"清空搜索数据！"];
            [self btnAction:self.searchBtn];
            ALERT(@"", @"是否清空搜索记录？");
            return;
        }
        
        self.normalField.text = self.dataSource[indexPath.row];
        [self btnAction:self.searchBtn];
         NSLog(@"------TableViewcell被点击-------");
    }
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
