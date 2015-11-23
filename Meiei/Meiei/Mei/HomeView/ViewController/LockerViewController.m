//
//  LockerViewController.m
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LockerViewController.h"
#import "HomeTableViewController.h"
#import "TabBarController.h"
#import "AppDelegate.h"
#import "VersionViewController.h"

@interface LockerViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (nonatomic, strong)NSString * cachingSize;
@property (nonatomic, assign)NSInteger currtColorNumber;
@property (nonatomic, assign)NSInteger currtNightNumber;
@end

@implementation LockerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currtColorNumber = 0;
    _currtNightNumber = 0;
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];

}
#pragma mark -
#pragma mark UITableView Delegate
// selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: // 返回HOME
        {
            [self.sideMenuViewController setContentViewController:[TabBarController new]];
        [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 1: // 夜间模式
        {
            UIView *rootView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
            //与window同样大
            UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            
            backView.backgroundColor = [UIColor blackColor];//darkGrayColor 0.3
            //透明度
            backView.alpha = 0.5;
            
            //要想点击view下的事件,要关闭view的用户交互
            backView.userInteractionEnabled = NO;
            
            if (_currtNightNumber == 0) {
                _currtNightNumber = 1;
                //在window的根视图控制器上添加透明子视图
                [rootView addSubview:backView];
            }else{
                _currtNightNumber = 0;
             //   [rootView willRemoveSubview:backView];
                [backView removeFromSuperview];
                [[rootView.subviews lastObject] removeFromSuperview];
            }
        }
            break;
        case 2: // 主题换肤
        {
            UIColor *color0 = [UIColor colorWithRed:1.000 green:0.347 blue:0.582 alpha:1.000];//初始粉
            UIColor *color1 = [UIColor colorWithRed:0.299 green:0.902 blue:0.868 alpha:0.900];// 青蓝
            UIColor *color2 = [UIColor colorWithRed:0.094 green:0.338 blue:0.882 alpha:1.000];// 藏蓝
            UIColor *color3 = [UIColor colorWithRed:1.000 green:0.439 blue:0.049 alpha:1.000];// 橙
            UIColor *color4 = [UIColor colorWithRed:1.000 green:0.560 blue:0.609 alpha:1.000];// 淡粉
            UIColor *color5 = [UIColor colorWithRed:0.778 green:0.622 blue:1.000 alpha:1.000];// 紫
            UIColor *color6 = [UIColor redColor];// 红
            
            NSArray *colorArray = @[color0,color1,color2,color3,color4,color5,color6];
            
            if (_currtColorNumber == (NSInteger)(colorArray.count-1)) {
                _currtColorNumber = 0;
            }else{
            _currtColorNumber++;
                
            }
            
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"color" object:nil userInfo:@{@"color":colorArray[_currtColorNumber]}];

            // 一键换肤 (所有导航条颜色都换了)
            [[UINavigationBar appearance] setBarTintColor:colorArray[_currtColorNumber]];

        }
            break;
        case 3: // 清理缓存
        {
            NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSFileManager * fileManager = [NSFileManager defaultManager];
            float folderSize;
            if ([fileManager fileExistsAtPath:cachePath])
            {
                
                NSArray * childerFiles = [fileManager subpathsAtPath:cachePath];
                
                for (NSString * fileName in childerFiles)
                {
                    NSString * fullPath = [cachePath stringByAppendingPathComponent:fileName];
                    folderSize = folderSize + [self fileSizeAtPath:fullPath];
                }
            }
            NSString * string = [NSString stringWithFormat:@"缓存大小为%.2fM", folderSize];
            self.cachingSize = string;
            
            
            [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: string,
                                                     KVNProgressViewParameterFullScreen: @(YES)}];
            
            
            if ([fileManager fileExistsAtPath:cachePath]) {
                NSArray * childerFiles = [fileManager subpathsAtPath:cachePath];
                for (NSString * fileName in childerFiles) {
                    NSString * absolutePath = [cachePath stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:absolutePath error:nil];
                }
            }
        }
            break;
        case 4: // 版本信息
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[VersionViewController alloc] init]]
                                                         animated:YES];

            [self.sideMenuViewController hideMenuViewController];
            
        }
            break;
        default:
            break;
    }
}

-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        
        return size/1024.0/1024.0;
    }
    return 0;
}
#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"herculanum" size:20];
        //cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    // @[@"❀心机小编帮你选❀", @"❀送女票", @"❀送男票", @"❀送家人", @"❀送自己"];
    NSArray *titles = @[@"我的首页", @"夜间模式", @"主题换肤", @"清理缓存", @"版本信息"];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
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
