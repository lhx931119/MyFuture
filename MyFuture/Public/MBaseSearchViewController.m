//
//  MBaseSearchViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/16.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MBaseSearchViewController.h"
#import "MSqiteManger.h"
#import "MMusic.h"
#import "AudioButton.h"
#import "AudioCell.h"

@interface MBaseSearchViewController ()<UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) MMusic *musicTool;
@end

@implementation MBaseSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSearchController];
    [self setNavController];
    
//    [self startSearchStatuWithStr:_searchStr];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"AudioCell" bundle:nil] forCellReuseIdentifier:@"AudioCell"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchController setActive:YES];
     self.searchController.searchBar.text = _searchStr;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _timerStartBloack();
}
#pragma mark --getter

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray *)searchResult
{

    if (!_searchResult) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}

- (MMusic *)musicTool
{
    if (!_musicTool) {
        _musicTool = [[MMusic alloc] init];
    }
    return _musicTool;
}

#pragma mark --privte
- (void)setSearchController
{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    
    self.searchController.dimsBackgroundDuringPresentation = false;
    
    //搜索栏表头视图
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.searchController.searchBar sizeToFit];
    
    //背景颜色
    
    self.searchController.searchBar.backgroundColor = [UIColor orangeColor];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
}


- (void)setNavController
{
    self.title = @"歌单列表";
    self.items =  [([[MSqiteManger shareMSqliteManger] executeQuerySQL:[NSString stringWithFormat:@"select * from %@", mUserMusicTable] arguments:nil]) mutableCopy];
//    self.items = [(@[@"德莱文",
//                   @"瑞文",
//                   @"流浪",
//                   @"卡萨丁",
//                   @"赵信",
//                   @"盖伦",
//                   @"阿卡丽",
//                   @"阿狸",
//                   @"剑圣",
//                   @"蝎子",
//                   @"螃蟹",
//                   @"蝙蝠",
//                   @"蛤蟆",
//                   @"波比",
//                     @"提莫"]) mutableCopy];
}

- (void)startSearchStatuWithStr:(NSString *)str
{
    
}


#pragma mark ---searchDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.searchResult removeAllObjects];
    //NSPredicate 谓词
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name contains %@",searchController.searchBar.text];
    self.searchResult = [[self.items filteredArrayUsingPredicate:searchPredicate]mutableCopy];
    //刷新表格
    [self.tableView reloadData];
    
}




#pragma mark ---tableDeleagte
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.musicTool audioPlayWithHttpAddress:self.searchResult[indexPath.row][@"address"]];
    
    //播放音乐
//    NSString *address = self.searchResult[indexPath.row][@"address"];
//    [self.searchController setActive:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//    _musicStartBlock(address);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

#pragma mark ---tableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableVie
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioCell"];
    
    NSDictionary *dic = self.searchResult[indexPath.row];
    [cell configurePlayerButton];
    cell.titleLabel.text = [dic objectForKey:@"name"];
    cell.artistLabel.text = [dic objectForKey:@"signer"];
    cell.audioButton.tag = indexPath.row;
    [cell.audioButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)playAudio:(AudioButton *)button
{
    NSInteger index = button.tag;
    NSDictionary *item = [self.searchResult objectAtIndex:index];
    
    if (_musicTool == nil) {
        _musicTool = [MMusic shareInstance];
    }
    
    if ([_musicTool.button isEqual:button]) {
        [_musicTool play];
    } else {
        [_musicTool stop];
        _musicTool.button = button;
        _musicTool.url = [NSURL URLWithString:[item objectForKey:@"address"]];
        [_musicTool play];
    }
}

@end
