//
//  VersionViewController.m
//  Meiei
//
//  Created by lanou3g on 15/11/21.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "VersionViewController.h"
#import "LockerViewController.h"

@interface VersionViewController ()



@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.787 blue:0.897 alpha:1.000];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❀" style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
    
#pragma mark --- picture
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2 - 50, kHeight / 5 , 100, 100)];
    imgView.image = [UIImage imageNamed:@"icon_lucency"];
    
#pragma mark --- name
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2 - 50, kHeight / 5 + 100, 100, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"我の礼物 1.0";
    
    [self.view addSubview:label];
    [self.view addSubview:imgView];
}

- (void)back{
    [self.sideMenuViewController hideMenuViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
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
