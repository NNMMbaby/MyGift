//
//  DetailView.m
//  Meiei
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "DetailView.h"

@interface DetailView ()<UIWebViewDelegate,UMSocialUIDelegate>

/**
 * headView 【title = 生活物语】
 * webView
 * bottomView 【back collect share】
 */

@property (nonatomic, retain)UIWebView * webView;
@property (nonatomic, retain)UIActivityIndicatorView * activityView;
@property (nonatomic, retain)UIButton * collectBtn;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation DetailView

// lazyLoad
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.459 blue:0.662 alpha:1.000];
    [self addView];
 
}
// 添加的全部视图
- (void)addView{
#pragma mark --- headView
    // 添加HeadView
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , kWidth, 70)];
    headView.backgroundColor = [UIColor colorWithRed:1.000 green:0.613 blue:0.726 alpha:1.000];
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, kWidth - 20, 40)];
    titleLabel.text = @"❀生活物语❀";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    [headView addSubview:titleLabel];
    
#pragma mark --- WebView
    // 添加webView
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 65, kWidth, kHeight - 114)];
    // 创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_liwu.content_url]];
    
    // 对页面进项自适应操作
    _webView.scalesPageToFit = YES;
    
    self.webView.delegate = self;
    [_webView loadRequest:request];
    
#pragma mark --- bottomView
    // 添加底栏 btn返回 + btn分享
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - 49, kWidth, 49)];
    bottomView.backgroundColor = [UIColor colorWithRed:1.000 green:0.847 blue:0.906 alpha:1.000];
    // back
    UIButton *btn4Back = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn4Back.frame = CGRectMake(15, 20, 50, 20);
    [btn4Back setTitle:@"返回" forState:(UIControlStateNormal)];
    btn4Back.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4Back setTitleColor:[UIColor colorWithRed:1.000 green:0.194 blue:0.239 alpha:1.000] forState:(UIControlStateNormal)];
    [btn4Back addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
    // collect
    //_right4Collect = 0;
    self.collectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _collectBtn.frame = CGRectMake(kWidth / 2 - 8, 20, 15, 15);
    [_collectBtn setImage:[UIImage imageNamed:@"ic_action_compact_favourite_normal"] forState:(UIControlStateNormal)];
    [_collectBtn addTarget:self action:@selector(collect) forControlEvents:(UIControlEventTouchUpInside)];
    
    // share
    UIButton *btn4Share = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn4Share.frame = CGRectMake(kWidth - 25, 20, 15, 15);
    [btn4Share setImage:[UIImage imageNamed:@"ic_action_compact_share"] forState:(UIControlStateNormal)];
    [btn4Share addTarget:self action:@selector(share) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [bottomView addSubview:btn4Back];
    [bottomView addSubview:btn4Share];
    [bottomView addSubview:_collectBtn];
    
    [self.view addSubview:headView];
    // [self.view addSubview:introduceLabel];
    [self.view addSubview:_webView];
    [self.view addSubview:bottomView];

}

// 返回
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 收藏
- (void)collect{
    
    if ([[DataBase sharedDataBase] selectAllLiwu].count == 0) {
        [[DataBase sharedDataBase] insertModel:_liwu];
    }else{
        
        if ([self returnResult]) {
            
            [[DataBase sharedDataBase] insertModel:_liwu];
            // 创建
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"小美提示" message:@"收藏成功" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertController addAction:defaultAction];
            // 添加视图
            [self presentViewController:alertController animated:YES completion:nil];

        }

    }
}

-(BOOL)returnResult {
    NSArray *array = [[DataBase sharedDataBase] selectAllLiwu];
    for (LiWu *lw in array) {
        if (_liwu.ID == lw.ID ) {
            // 创建
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"小美提示" message:@"已经收藏了哦~~" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertController addAction:defaultAction];
            // 添加视图
            [self presentViewController:alertController animated:YES completion:nil];

            return NO;
            
        }else{
            
        }
    }
    return YES;
}

// 分享
- (void)share{

    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"564fe45ee0f55a469300166c"
                                      shareText:[NSString stringWithFormat:@"这里面的西礼物分享给亲哦~%@", _liwu.content_url ]
                                     shareImage:[UIImage imageNamed:@"22"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:self];
}
// 分享完的回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


// 网页开始加载时调用
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    // 创建UIActivityIndictorView的背景视图
    UIView *aView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    aView.backgroundColor = [UIColor blackColor];
    aView.alpha = 0.4;
    aView.tag = 1001;
    [self.view addSubview:aView];
    // 加载指示视图
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _activityView.center = aView.center;
    [_activityView setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [aView addSubview:_activityView];
    [_activityView startAnimating];
    NSLog(@"网页开始加载");
}

// 完成加载
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 停止动画
    [_activityView stopAnimating];
    
    // 从视图上移除
    UIView *view = (UIView *)[self.view viewWithTag:1001];
    [view removeFromSuperview];
    NSLog(@"网页加载完毕");
    
}

// 加载错误时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_activityView stopAnimating];
    
    // 从事图赏移除
    UIView *view = (UIView *)[self.view viewWithTag:1001];
    [view removeFromSuperview];
    
    NSLog(@"加载错误：%@",error);
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
