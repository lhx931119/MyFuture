//
//  MUserViewController.m
//  MyFuture
//
//  Created by 李宏鑫 on 16/4/7.
//  Copyright © 2016年 hongxinli. All rights reserved.
//

#import "MUserViewController.h"
#import "CustomTabBarController.h"
#import "MLogoutViewController.h"
#import "MUserManger.h"

@interface MUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars@2x.png"]];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.opaque = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;

    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
//    NSArray *titles = @[@"Home", @"Calendar", @"Profile", @"Settings"];
    NSArray *images = @[@"IconHome@2x.png", @"IconCalendar@2x.png", @"IconProfile@2x.png", @"IconSettings@2x.png"];
//    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            
        {
            UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
            BOOL result = [nav.childViewControllers[0] isKindOfClass:[CustomTabBarController class]];
            if (result) {
                [self.sideMenuViewController setContentViewController:nav animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            }else{
                CustomTabBarController *custom = [[CustomTabBarController alloc] init];
                custom.selectIndex = [MUserManger shareInstance].index;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:custom];
                [self.sideMenuViewController setContentViewController:nav animated:YES];
                [self.sideMenuViewController hideMenuViewController];
            }
        }
            break;
         case 1:
        {
            
        }
            break;
        case 2:
        {
        
        }
            break;
         case 3:
        {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MLogoutViewController alloc] init]];
            [self.sideMenuViewController setContentViewController:nav animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        default:
            break;
    }
}
@end
