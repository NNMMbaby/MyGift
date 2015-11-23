//
//  TabBarController.m
//  Meiei
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "TabBarController.h"
#import "HomeTableViewController.h"
#import "RecommendTableViewController.h"
#import "FavoriteTableViewController.h"

#import "LockerViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 三个页面
    HomeTableViewController *homeTVC = [[HomeTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeTVC];
    RecommendTableViewController *movVC = [[RecommendTableViewController alloc ] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:movVC];
    FavoriteTableViewController *cinTVC = [[FavoriteTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:cinTVC];

    
    // 透明度
    nav1.navigationBar.translucent = NO;
    nav2.navigationBar.translucent = NO;
    nav3.navigationBar.translucent = NO;

    // 改变tabar颜色
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    backView.backgroundColor = [UIColor colorWithRed:1.000 green:0.266 blue:0.562 alpha:1.000];
    [self.tabBarController.tabBar insertSubview:backView atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
   
    
    // 字面量数组 添加为item模块
    self.viewControllers =  @[nav1,nav2,nav3];

    // 一键换肤 (所有导航条颜色都换了)
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:230/255.0 green:85/255.0 blue:128/255.0 alpha:0.9]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // 风格 和初始页面
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:230/255.0 green:85/255.0 blue:128/255.0 alpha:0.9];

    
    self.selectedIndex = 0;
    
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
