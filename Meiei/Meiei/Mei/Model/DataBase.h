//
//  DataBase.h
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LiWu;
@interface DataBase : NSObject

// 创建单利
+ (DataBase *)sharedDataBase;

//创建表
-(void)createTable;

// 打开数据库的方法
-(void) openDB;

// 关闭数据库的方法
-(void) closeDB;

// 增加
-(void) insertModel:(LiWu *)liwu;

// 删除
-(void)delelteModelByID:(NSInteger)LiwiuID;

// 查询所有用户
-(NSArray *)selectAllLiwu;

// 查询某个liwu

//- (LiWu *)selectLiwuWithID:(NSString *)ID;

- (BOOL)selectByID:(NSString *)ID;

@end
