//
//  DiscoverViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/1/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "DiscoverViewController.h"
#import "MMoveTableViewCell.h"
#import "CustomTabBarController.h"
#import "MMoviePlayViewController.h"
#import "Custom.h"
#import "MUserManger.h"
#import "MMoiveBar.h"

@interface DiscoverViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  Custom *movieHeadView;

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  MMoiveBar *barView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *currentDataSource;

@property (nonatomic, assign) NSInteger index;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"discover";
    self.view.backgroundColor = [UIColor whiteColor];
    //添加滚动式图
    [self.view addSubview:self.movieHeadView];
    [self.view addSubview:self.tableView];
 
//    [self.navigationController.navigationBar addSubview:self.barView];
    
//    self.navigationController.navigationBar.translucent = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
  /*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 50)];
    [flowLayout setItemSize:CGSizeMake(50, 30)];
//    [flowLayout minimumLineSpacing]
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    _collection.delegate = self;
    _collection.dataSource = self;
    [self.view addSubview:_collection];
    
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"movieCell"];
    [self.collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"movieResultView"];
    _collection.backgroundColor = [UIColor whiteColor];
//
    // Do any additional setup after loading the view.*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_movieHeadView startTimer];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_movieHeadView stopTimer];
    

}
#pragma mark --- setter

- (Custom *)movieHeadView
{
    if (!_movieHeadView) {
        _movieHeadView  = [[Custom alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 100) isGuide:NO];
        _movieHeadView.backgroundColor = [UIColor blackColor];
        [_movieHeadView autoStartView:YES];
    }
    return _movieHeadView;
}

- (MMoiveBar *)barView
{
    if (!_barView) {
        _barView  = [[MMoiveBar alloc] initWithIcnPath:@"userDefault.png"];
    }
    return _barView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        CGFloat temp = CGRectGetMaxY(self.movieHeadView.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, temp, self.view.frame.size.width,self.view.frame.size.height - temp) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellClass"];
        
   UIView *headView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 5)];
        headView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = headView;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MMoveTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellClass"];
        _tableView.rowHeight = 115;
        
        __weak typeof(UITableView) *weakTable = _tableView;
        __weak typeof(self) weakSelf = self;
        //下拉刷新
        [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf loadNewData];
                [weakTable headerEndRefreshingWithResult:JHRefreshResultSuccess];
//                weakTable.contentOffset = CGPointMake(0, 25);
            });
        }];
        
        //上拉加载更多
        
        [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
            
            //延时隐藏refreshView;
            double delayInSeconds = 2.0;
            //创建延期的时间 2S
            dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            //延期执行
            dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
                //事情做完了别忘了结束刷新动画~~~
                [weakSelf loadMoreData];
                [weakTable reloadData];
//                weakTable.contentOffset = CGPointMake(0, 25);
                [weakTable footerEndRefreshing];
            });
            
        }];

        //首次刷新
//        [_tableView headerStartRefresh];
        
    }
    return _tableView;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    NSLog(@"----key = %@, objc = %@, change = %@, context= %@", keyPath, object, change, context);
//}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MLoLs" ofType:@"plist"];
        _dataSource = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return _dataSource;
}

- (NSMutableArray *)currentDataSource
{
    if (!_currentDataSource) {
        _currentDataSource = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            _index ++;
//            if (_index == 16) {
//                _index = 0;
//            }
            [_currentDataSource addObject:self.dataSource[_index]];
        }
    }
    return _currentDataSource;
}
//#pragma mark -- delegate

#pragma mark --privte

///加载更多数据
- (void)loadMoreData
{
  
    for (int i = 0; i < 8; i++) {
        _index ++;
        if (_index  >= 17) {
            return;
        }
        [self.currentDataSource addObject:self.dataSource[_index]];
    }
    
}

///刷新新数据
- (void)loadNewData
{
    [self.currentDataSource removeAllObjects];
    self.currentDataSource = nil;
    _index = 0;
    [_tableView reloadData];
}

#pragma mark -- datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentDataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    MMoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellClass"];
    NSDictionary *dic = self.currentDataSource[indexPath.row];
    cell.dic = dic;
    return cell;
}

#pragma mark -- degelate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomTabBarController *controller = [MUserManger shareInstance].controller;
    
    MMoviePlayViewController *player = [[MMoviePlayViewController alloc] init];
    player.path = self.currentDataSource[indexPath.row][@"address"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    controller.navigationItem.backBarButtonItem = item;
    [controller.navigationController pushViewController:player animated:YES];

    NSLog(@"-----%@----",controller.navigationController);
}


//- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//
//    return 10;
//}
//
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 2;
//}
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identify = @"movieCell";
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
//    [cell sizeToFit];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 256.0 green:arc4random() % 255 / 256.0 blue:arc4random() % 255 / 256.0 alpha:1.0];
//    return cell;
//}
//
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"movieResultView" forIndexPath:indexPath];
//    
//    [headView addSubview:self.movieHeadView];
//    
//    return headView;
//}
//#pragma mark -- flowLayoutDelegate
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    return CGSizeMake(50, 30);
//    
//}
//
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 5, 5, 5);
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(self.view.frame.size.width, 30);
//
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(self.view.frame.size.width, 30);
//}


@end
