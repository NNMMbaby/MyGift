//
//  RecommendTableViewController.m
//  Meiei
//
//  Created by lanou3g on 15/11/13.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "RecommendTableViewController.h"
#import "TableViewCell.h"
#import "DetailView.h"
#import "LiWu.h"

@interface RecommendTableViewController ()<HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>

@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (nonatomic, strong) NSArray *meiArray;

@property (nonatomic, strong) UILabel *selectedItemLabel;

// 解析数据数组
@property (nonatomic, strong)NSMutableArray * postArray;
// 解析数据的URL_ARRAY
@property (nonatomic, strong)NSArray * URL_Array;

// current
@property (nonatomic, strong)NSString *currentString;

// 请求数据加载时候的下一页 0 ，20 ，40，。。。。。
@property (nonatomic, assign)NSInteger currentOffSet;


@end

@implementation RecommendTableViewController

static NSString *Identifier2 = @"cellIdentifier2";

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"小美推荐";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"小美推荐" image:[UIImage imageNamed:@"minddle" ] tag:1001];
        
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❀" style:(UIBarButtonItemStylePlain) target:self action:@selector(presentLeftMenuViewController:)];

        _currentString = URL_oGIFT;
        [self parser];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeColor:) name:@"color" object:nil];
    // URL 数据组对应
    self.URL_Array = @[URL_oGIFT,URL_oWEAR,URL_oFOOD,URL_oHANDWORK,URL_oGOODS,URL_oORNAMENT,URL_oBEAUTY,URL_oSHOSEANDBAG,URL_oELECTION,URL_oFUNNY,URL_oCARTOON];
    
    // navigationBarTintColor
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];

    // 隐藏竖条
    self.tableView.showsVerticalScrollIndicator = NO;

    //注册
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:Identifier2];
 // 添加 selectionList
    [self addSelectionList];
// 添加 下拉刷新 上拉加载
    [self addRefreshAndLoad];
}
- (void)ChangeColor:(NSNotification *)sender{
    
    self.navigationController.navigationBar.barTintColor = sender.userInfo[@"color"];
    // 改变tabBarItem颜色
    self.tabBarController.tabBar.tintColor = sender.userInfo[@"color"];
}



#pragma mark -- 方法：selectionList
- (void)addSelectionList{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    
    self.meiArray = @[@"礼物",
                      @"穿搭",
                      @"美食",
                      @"手工",
                      @"美物",
                      @"饰品",
                      @"美护",
                      @"鞋包",
                      @"数码",
                      @"娱乐",
                      @"动漫"];
    
   // [self.view addSubview:self.selectionList];
    
    // 添加到头视图上
   // self.tableView.tableHeaderView = self.selectionList;
    
    self.selectedItemLabel = [[UILabel alloc] init];
    self.selectedItemLabel.text = self.meiArray[self.selectionList.selectedButtonIndex];
    
    self.selectedItemLabel.translatesAutoresizingMaskIntoConstraints = NO;
}



#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.meiArray.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {

    return self.meiArray[index];

}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    self.selectedItemLabel.text = self.meiArray[index];
    
    if (!_currentString) {
        _currentString = nil;
    }
    
    if (_postArray.count != 0 ) {
        
        [_postArray removeAllObjects];
        NSLog(@"<<<<%ld",_postArray.count);
    }
    [self.tableView reloadData];
    // 对应的 URL
    _currentString = _URL_Array[index];
    NSLog(@"解析的URL:%@",_currentString);
    
    [self parser];
    [self.tableView reloadData];

}
#pragma mark --方法：下拉刷新 上拉加载
- (void)addRefreshAndLoad{
    
    // 下拉刷新菜单
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self parser];
        
        [self.tableView reloadData];
        
        // 模拟延迟加载数据，因此2秒后才调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [tableView.mj_header endRefreshing];
        });
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 数据拼接加载
            _currentOffSet += 20;
            [self parser];
            // 结束刷新
            [tableView.mj_footer endRefreshing];
        });
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //  [self.tableView mj_reloadDataBlock];
    return _postArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier2 forIndexPath:indexPath];
    // 隐藏点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LiWu *lwModel = [LiWu new];
    lwModel = _postArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:lwModel.cover_image_url] placeholderImage:[UIImage imageNamed:@"placeImage"]];
    
    cell.infoLabel.text = lwModel.share_msg;
    
    //NSLog(@"%@",lwModel.share_msg);
    
    return cell;
}
// 选择跳到详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailView *detailVC = [[DetailView alloc] init];
    LiWu *lwModel = [LiWu new];
    
    lwModel = _postArray[indexPath.row];
    
    detailVC.liwu = lwModel;
    
    [self showDetailViewController:detailVC sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.selectionList;
}



#pragma 懒加载
-(NSMutableArray *)postArray{
    if (!_postArray) {
        self.postArray = [NSMutableArray array];
    }
    return _postArray;
}

#pragma mark -- 数据解析

//- (void)parser:(NSString *)sendURL{
- (void)parser{
//    
//    if (_postArray.count !=0) {
//
//        [_postArray removeAllObjects];
//        NSLog(@"<<<<%ld",_postArray.count);
//        
//    }
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld", _currentString,_currentOffSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)temp = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *dataDic = dictionary[@"data"];
        NSArray *postArray = dataDic[@"items"];
        
        NSLog(@"————————————postArray.count:————————————%ld",postArray.count);
        
        for (NSDictionary *dic in postArray) {
            
            LiWu *liwuModel = [LiWu new];
            [liwuModel setValuesForKeysWithDictionary:dic];
            [temp.postArray addObject:liwuModel];
            
        }
        
       dispatch_async(dispatch_get_main_queue(), ^{
            [temp.tableView reloadData];
       });
        
//        NSLog(@"_postArray.count： %ld",_postArray.count);
//                for (LiWu *lw in _postArray) {
//                    NSLog(@"%@",lw.title);
//                }
        
    }];
    [task resume];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
