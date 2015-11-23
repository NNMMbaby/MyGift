//
//  FavoriteTableViewController.m
//  Meiei
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "FavoriteTableViewController.h"
#import "DetailView.h"

@interface FavoriteTableViewController ()
// 礼物
@property (nonatomic, retain)NSArray *cellArray;
@property (nonatomic, retain)NSArray *cellImgArray;

// 收藏
@property (nonatomic, retain)NSMutableArray *favorArray;

/**
 * headView =  imgView
 * 我的收藏
 *
 *
 */

@property (nonatomic, retain)UIImageView *bottomView;
@property (nonatomic, retain)UIImageView *hpView;

@end

@implementation FavoriteTableViewController

static NSString *Identifier3 = @"cellIdentifier3";

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"礼物";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"礼物" image:[UIImage imageNamed:@"gift" ] tag:1001];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❀" style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
        
        // 添加背景图片
        self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight * 0.35)];
        _bottomView.image = [UIImage imageNamed:@"d"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加头视图
    
    self.tableView.tableHeaderView = self.bottomView;
    
    // navigationBarTintColor
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];

    // 注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier3];

    // 隐藏竖条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    // 隐藏横线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeColor:) name:@"color" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)favorArray{
    if (!_favorArray) {
        self.favorArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _favorArray;
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",[[DataBase sharedDataBase] selectAllLiwu].count);
    return [[DataBase sharedDataBase] selectAllLiwu].count;

}
// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier3 forIndexPath:indexPath];
    
    // 隐藏点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *array = [[DataBase sharedDataBase] selectAllLiwu];
    NSLog(@"%ld",array.count);
    LiWu *liwu = array[indexPath.row];
    cell.textLabel.text = liwu.share_msg;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithRed:0.096 green:0.317 blue:0.346 alpha:0.700];
    cell.imageView.image = [UIImage imageNamed:@"giftFamily"];

    return cell;
}

- (void)ChangeColor:(NSNotification *)sender{
    
    self.navigationController.navigationBar.barTintColor = sender.userInfo[@"color"];
    // 改变tabBarItem颜色
    self.tabBarController.tabBar.tintColor = sender.userInfo[@"color"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @" 我喜欢你       我の礼物";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.tableView reloadData];
    
}

// 删除
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 先删数据
        LiWu *liwu = [[DataBase sharedDataBase]selectAllLiwu][indexPath.row];
        
        [[DataBase sharedDataBase]delelteModelByID:liwu.ID];
        
        // 再删cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [[DataBase sharedDataBase]selectAllLiwu];
    LiWu *lw = array[indexPath.row];
    DetailView *detailView = [[DetailView alloc] init];
    detailView.liwu = lw;
    [self presentViewController:detailView animated:YES completion:nil];
    
    
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
