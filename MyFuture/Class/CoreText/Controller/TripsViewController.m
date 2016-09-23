//
//  TripsViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/1/4.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "TripsViewController.h"
#import "CTTextDisplayView.h"
#import "TripsTableViewCell.h"
#import "NSString+Category.h"

#import "WXApiObject.h"
#import "WXApi.h"


@interface TripsViewController ()<UITableViewDelegate, UITableViewDataSource, CTTextDisplayViewDelegate>

/*
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *rowHeightAry;
@property (nonatomic, strong) CTTextDisplayView *textView;
@property (nonatomic, strong) CTTextStyleModel *model;
*/

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"trips";
    
    [self.view addSubview:self.tableView];

//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.view addSubview:self.textView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"testList" ofType:@"plist"];
        _dataSource = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return _dataSource;
}


#pragma mark ---setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
        [_tableView registerClass:[TripsTableViewCell class] forCellReuseIdentifier:@"cellidentity"];
        
        UIView *headView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 5)];
        headView.backgroundColor = [UIColor whiteColor];
        [_tableView setTableHeaderView:headView];
        
        typeof(self) weakSelf = self;
        
        //下拉刷新
        [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
            
            //加载新数据
            [weakSelf loadNewData];
            
            //刷新表格
            [weakSelf.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //结束刷新
                [weakSelf.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];

                
            });
        }];
        
        //上拉加载
        
        [_tableView  addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
            
            //加载更多数据
            [weakSelf loadMoreData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //刷新表格
                [weakSelf.tableView reloadData];
                
                //结束上拉加载
                [weakSelf.tableView footerEndRefreshing];
            });
        }];
//        [_tableView registerNib:[UINib nibWithNibName:@"TripsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellidentity"];
    }
    return _tableView;
}


- (void)loadMoreData
{
    
}

- (void)loadNewData
{

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    TripsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellidentity"];
    cell.dic = self.dataSource[indexPath.row];
    typeof(self) weakSelf = self;
    typeof(TripsTableViewCell *)weakCell = cell;
    cell.block = ^(){
        NSLog(@"---触发长按---");
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = weakSelf.dataSource[indexPath.row][@"content"];
        req.bText = YES;
        req.scene = weakCell.type;
        [WXApi sendReq:req];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return [TripsTableViewCell rowHeightWithDic:self.dataSource[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSString *text =  @"${李四} 回复 ${王麻子}[拜拜]视]我@{张三:12}自[鄙www.baidu.com[拜拜][悲伤]视]横[悲伤]刀[拜拜]向天笑[拜拜]，@{去留肝胆两昆}仑。This is my first CoreText #{周杰伦:23} https://www.google.com/ demo,how are you ?I [拜拜] love three thi \ue056 n[拜拜]gs,the sun,the moon,and you.the sun for the day,themoon for the night,and you forever.去[拜拜]年今年今年今@{张三人asdf面桃花}相映红人面桃花相映红日此门中，人面桃花相映红。头，有恨无人省。捡尽寒枝不肯栖，寂寞沙洲冷。[拜拜]独往来[鄙视][悲伤],.说愁";
        [_dataSource addObject:text];
    }
    return _dataSource;

}

- (CTTextDisplayView *)textView
{

    if (!_textView) {
        
        CGFloat rowHeight = [[self.rowHeightAry firstObject] floatValue];
        
       _textView =  [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width-10, rowHeight)];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor redColor];
        _textView.styleModel = self.model;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.text = [self.dataSource firstObject];
        
    }
    return _textView;
}

- (NSMutableArray *)rowHeightAry
{
    if (!_rowHeightAry) {
        _rowHeightAry = [NSMutableArray array];
        CGFloat rowHeight = [CTTextDisplayView getRowHeightWithText:[self.dataSource firstObject] rectSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-10, CGFLOAT_MAX) styleModel:self.model];
        [_rowHeightAry addObject:[NSNumber numberWithFloat:rowHeight]];

    }
    return _rowHeightAry;
}


- (CTTextStyleModel *)model
{
    if (!_model) {
        _model = [CTTextStyleModel new];
        _model.font = [UIFont systemFontOfSize:25];
        _model.faceSize = CGSizeMake(40, 40);
        _model.faceOffset = 11;
        _model.lineSpace = 8.0f;
        _model.numberOfLines = -1;
        _model.highlightBackgroundRadius = 5;
        _model.emailColor = [UIColor orangeColor];
        _model.phoneColor = [UIColor redColor];
        _model.subjectColor = [UIColor greenColor];
           }
    return _model;
}



#pragma mark -  CTTextDisplayViewDelegate

- (void)ct_textDisplayView:(CTTextDisplayView *)textDisplayView obj:(id)obj{
    NSLog(@"key: %@          value: %@",obj[@"key"],obj[@"value"]);
}




#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowHeightAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return ((NSNumber *)[self.rowHeightAry objectAtIndex:indexPath.row]).floatValue+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIndefi"];
    CTTextDisplayView * textDisplayView = [[CTTextDisplayView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10, 1)];
    textDisplayView.tag = 100;
    textDisplayView.delegate = self;
    textDisplayView.styleModel = self.model;
    CGRect textViewFrame = textDisplayView.frame;
    textViewFrame.size.height = ((NSNumber *)[self.rowHeightAry objectAtIndex:indexPath.row]).floatValue;
    textDisplayView.frame = textViewFrame;
    textDisplayView.text = self.dataSource[indexPath.row];

    textDisplayView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:textDisplayView];

    return cell;
}
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
