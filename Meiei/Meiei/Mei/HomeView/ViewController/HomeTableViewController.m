//
//  HomeTableViewController.m
//  Meiei
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "HomeTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LockerViewController.h"
#import "TableViewCell.h"
#import "DetailView.h"
#import "Banners.h"


#define kNumber 6   // 轮播图个数

@interface HomeTableViewController ()
// 轮播图头视图
@property (nonatomic, retain)UIView * headView;
@property (nonatomic, retain)UIScrollView * scrollView;
@property (nonatomic, retain)UIPageControl * pageControl;
@property (nonatomic, strong)NSTimer * timer;
// cell 介绍
@property (nonatomic, retain)UILabel *introduceLabel;

// 轮播图数组
@property (nonatomic, strong)NSMutableArray * bannerArray;

// 解析数据数组
@property (nonatomic, strong)NSMutableArray * postArray;

// 解析数据拼接
@property (nonatomic, assign)NSInteger currentOffSet;

@end

@implementation HomeTableViewController

static NSString *Identifier1 = @"cellIdentifier1";

 //隐藏状态栏
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (instancetype)initWithStyle:(UITableViewStyle)style{

    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"首页";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"home1" ] tag:1001];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❀" style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];
        [self dataParser];
        [self tenGoodsParser];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    // 改变 navigationBarTintColor
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    
    // 改变tabBarItem颜色
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:1.000 green:0.347 blue:0.582 alpha:1.000];

    // 隐藏竖条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 隐藏横线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:Identifier1];
    
    // 接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeColor:) name:@"color" object:nil];

#pragma mark headView--ScrollView
    // 头视图设置为轮播图
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kWidth -  10, 230)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    // cell 介绍
    self.introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 185, kWidth- 10, 40)];
    _introduceLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.741 blue:0.806 alpha:1.000];
    _introduceLabel.layer.masksToBounds = YES;
    _introduceLabel.layer.cornerRadius = 4;
    _introduceLabel.text = @"    ❀  亲爱的~   小美每天为您推荐十个物语新品哟~~~  ❀ ";
    _introduceLabel.textAlignment = NSTextAlignmentCenter;
    _introduceLabel.font = [UIFont systemFontOfSize:13];
    _introduceLabel.textColor = [UIColor whiteColor];
    
    [_headView addSubview:_introduceLabel];
    
    self.tableView.tableHeaderView = _headView;
    
    // 滚动代理
    self.scrollView.delegate = self;
    // 轮播视图
    [self addRollView];
    // 交互
    _headView.userInteractionEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    // 添加计时器
    [self addTimer];

#pragma mark ---- 下拉刷新 上拉加载
    // 下拉刷新菜单
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];

            // 结束刷新
            [tableView.mj_header endRefreshing];
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 数据拼接加载
            _currentOffSet += 20;
            [self tenGoodsParser];
            
            // 结束刷新
            [tableView.mj_footer endRefreshing];
        });
    }];
  
}

- (void)ChangeColor:(NSNotification *)sender{

    self.navigationController.navigationBar.barTintColor = sender.userInfo[@"color"];
    // 改变tabBarItem颜色
    self.tabBarController.tabBar.tintColor = sender.userInfo[@"color"];
}

// 添加轮播图
- (void)addRollView{
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5,kWidth - 10, 180 )];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake((kWidth - 10) *5, 180);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
#pragma mark ----取出解析数据添加到轮播图
    // 添加图片
    for (int i = 0; i < 5; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth - 10) * i, 0, kWidth - 10 , 180) ];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        Banners *ban = _bannerArray[i];
        NSLog(@"%@",ban.target_id);
        [imgView sd_setImageWithURL:[NSURL URLWithString:ban.image_url] placeholderImage:[UIImage imageNamed:@" "]];
        
        [_scrollView addSubview:imgView];
    }
    
    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(250, 170, 110, 10)];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [_headView addSubview:_scrollView];
    [_headView addSubview:_pageControl];
    
}
#pragma mark PageControl控制图片
- (void)pageControlAction:(UIPageControl *)sender{
    NSInteger currentPage = sender.currentPage;
   // NSLog(@"%ld",currentPage);
    _scrollView.contentOffset = CGPointMake(currentPage * (kWidth -10), 0);
    
}

// 添加定时器
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(2.0) target:self selector:@selector(nextImage:) userInfo:nil repeats:YES];
}

// 计时器方法
- (void)nextImage:(NSTimer *)sender{
    int page = (int)self.pageControl.currentPage;
    if (page == 4) {
        page = 0;
    }else{
        page ++;
    }
    CGFloat x = page *(kWidth - 10);
    self.scrollView.contentOffset = CGPointMake(x, 0);
}

// 关闭计时器
/*
- (void)removeTimer{
    [self.timer invalidate];
}*/

// 滚动之后仍自动滚动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView{
    [self addTimer];
}

// 滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算页码 页码滚动
    CGFloat scrollRoll = _scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollRoll/2)/scrollRoll;
    self.pageControl.currentPage = page;
    
}

#pragma mark ----  解析 轮播图 数据
- (void)dataParser{
    
    
    NSURL *URL = [NSURL URLWithString:URL_BANNERS];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)temp = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *dataDic = dictionary[@"data"];
        NSArray *bannersArray = dataDic[@"banners"];
     //   NSLog(@" %ld",bannersArray.count);
        temp.bannerArray = [NSMutableArray arrayWithCapacity:5];
        for (NSDictionary *dic in bannersArray) {
            
            Banners *banModel = [Banners new];
            [banModel setValuesForKeysWithDictionary:dic];
            
            [temp.bannerArray addObject:banModel];
           // NSLog(@"%@",banModel.target_id);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.tableView reloadData];
            [temp addRollView];
        });
        
//        for (Banners *ban in _bannerArray) {
//            NSLog(@"%@",ban.target_id);
//        }
        
    }];
    [task resume];
    
}

// lazyLoad
- (NSMutableArray *)postArray{
    if (!_postArray) {
        self.postArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _postArray;
}


#pragma mark ----  解析 十件美物 数据
- (void)tenGoodsParser{
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld", URL_BEAUTYGOODS,_currentOffSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)temp = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *dataDic = dictionary[@"data"];
        NSArray *postArray = dataDic[@"posts"];
     //   temp.postArray = [NSMutableArray arrayWithCapacity:5];
        for (NSDictionary *dic in postArray) {
            
            LiWu *liwuModel = [LiWu new];
            [liwuModel setValuesForKeysWithDictionary:dic];
            [temp.postArray addObject:liwuModel];

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.tableView reloadData];
        });
        
                for (LiWu *lw in _postArray) {
                    NSLog(@"%@",lw.title);
                }
        
    }];
    [task resume];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _postArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier1 forIndexPath:indexPath];
        // 隐藏点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    LiWu *lwModel = [LiWu new];
    lwModel = _postArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:lwModel.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
    cell.infoLabel.text = lwModel.share_msg;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailView *detailVC = [[DetailView alloc] init];
    
    LiWu *lwModel = [LiWu new];
    lwModel = _postArray[indexPath.row];
    NSLog(@"yyy%ld",lwModel.ID);
    detailVC.liwu = lwModel;
    
    [self showDetailViewController:detailVC sender:nil];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
