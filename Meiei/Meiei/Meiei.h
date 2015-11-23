//
//  Meiei.h
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#ifndef Meiei_h
#define Meiei_h

/*************************【首页 资源接口】*****************************/

#define URL_BANNERS @"http://api.liwushuo.com/v1/banners?channel=iOS"       // 轮播图

#define URL_BEAUTYGOODS @"http://api.liwushuo.com/v1/collections/22/posts?gender=1&generation=4&limit=20&offset=" // 十个美好小物

//第二个tabBar 单品
#define URL_singleGoods @"http://api.liwushuo.com/v2/items?gender=1&generation=4&limit=20&offset=0"
//下页
#define URL_singleGoods_nextPage @"http://api.liwushuo.com/v2/items?gender=1&generation=4&limit=20&offset=20"

/*************************【推荐分类 资源接口】*****************************/

/*
#define URL_oGIFT @"http://api.liwushuo.com/v1/channels/111/items?limit=20&offset=0"      // 礼物

#define URL_oWEAR @"http://api.liwushuo.com/v1/channels/110/items?limit=20&offset=0"      // 穿搭

#define URL_oFOOD @"http://api.liwushuo.com/v1/channels/118/items?limit=20&offset=0"      // 美食

#define URL_oHANDWORK @"http://api.liwushuo.com/v1/channels/3/items?limit=20&offset=0"      // 手工

#define URL_oGOODS @"http://api.liwushuo.com/v1/channels/2/items?limit=20&offset=0"      // 美物

#define URL_oORNAMENT @"http://api.liwushuo.com/v1/channels/116/items?limit=20&offset=0"      // 饰品

#define URL_oBEAUTY @"http://api.liwushuo.com/v1/channels/113/items?limit=20&offset=0"      // 美护

#define URL_oSHOSEANDBAG @"http://api.liwushuo.com/v1/channels/117/items?limit=20&offset=0"      // 鞋包

#define URL_oELECTION @"http://api.liwushuo.com/v1/channels/121/items?limit=20&offset=0"      // 数码

#define URL_oFUNNY @"http://api.liwushuo.com/v1/channels/120/items?limit=20&offset=0"      // 娱乐

#define URL_oCARTOON @"http://api.liwushuo.com/v1/channels/122/items?limit=20&offset=0"      // 动漫
*/


#define URL_oGIFT @"http://api.liwushuo.com/v1/channels/111/items?limit=20&offset="      // 礼物

#define URL_oWEAR @"http://api.liwushuo.com/v1/channels/110/items?limit=20&offset="      // 穿搭

#define URL_oFOOD @"http://api.liwushuo.com/v1/channels/118/items?limit=20&offset="      // 美食

#define URL_oHANDWORK @"http://api.liwushuo.com/v1/channels/3/items?limit=20&offset="      // 手工

#define URL_oGOODS @"http://api.liwushuo.com/v1/channels/2/items?limit=20&offset="      // 美物

#define URL_oORNAMENT @"http://api.liwushuo.com/v1/channels/116/items?limit=20&offset="      // 饰品

#define URL_oBEAUTY @"http://api.liwushuo.com/v1/channels/113/items?limit=20&offset="      // 美护

#define URL_oSHOSEANDBAG @"http://api.liwushuo.com/v1/channels/117/items?limit=20&offset="      // 鞋包

#define URL_oELECTION @"http://api.liwushuo.com/v1/channels/121/items?limit=20&offset="      // 数码

#define URL_oFUNNY @"http://api.liwushuo.com/v1/channels/120/items?limit=20&offset="      // 娱乐

#define URL_oCARTOON @"http://api.liwushuo.com/v1/channels/122/items?limit=20&offset="      // 动漫


/*************************【适配】*****************************/

#define kNumber 6 // 轮播图个数

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

/*************************【JJJ】*****************************/



#endif /* Meiei_h */
