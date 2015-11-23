//
//  DataBase.m
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "DataBase.h"
#import "LiWu.h"
#import <sqlite3.h>

@implementation DataBase

static DataBase *dataBase = nil;

+ (DataBase *)sharedDataBase{
    @synchronized(self) {
        if (dataBase == nil) {
            dataBase = [[DataBase alloc] init];
            // 打开数据库
            [dataBase createTable];
        }
        
    }
    return dataBase;
}

// 创建数据库对象
static sqlite3 *db = nil;

// 打开数据库的方法
-(void) openDB{
    
    if (nil != db) {
        return;
    }
    //创建路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"liwu.sqlite"];
    NSLog(@"%@", path);
    //打开数据库
    
    int result = sqlite3_open([path UTF8String], &db);
    if (result == SQLITE_OK) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败，错误操作为%d",result);
    }
}

// 关闭数据库的方法
-(void) closeDB{
    
    int result = sqlite3_close(db);
    
    if (result == SQLITE_OK) {
        db = nil;
        NSLog(@"关闭成功");
    }else{
        NSLog(@"关闭失败，错误操作数为%d",result);
    }
    
}

//创建表
-(void)createTable{
    
    [self openDB];
    
    //准备sql语句
    NSString *createString = @"CREATE TABLE IF NOT EXISTS 'favorite' ('ID' INTEGER PRIMARY KEY NOT NULL, 'content_url' TEXT NOT NULL, 'cover_image_url' TEXT NOT NULL, 'share_msg' TEXT NOT NULL, 'title' TEXT NOT NULL)";
    int result =  sqlite3_exec(db, createString.UTF8String, NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        NSLog(@"创建成功");
    }else{
        NSLog(@"创建失败，错误操作数为%d",result);
    }
    [self closeDB];
    
}

// 增加
-(void)insertModel:(LiWu *)liwu{
    
    [self openDB];
    
    //ID, content_url, cover_image_url, share_msg, title
    NSString *insertString = [NSString stringWithFormat:@"insert into 'favorite' (ID, content_url, cover_image_url, share_msg, title) values ('%ld','%@','%@','%@','%@')",liwu.ID, liwu.content_url,liwu.cover_image_url,liwu.share_msg,liwu.title];//不区分大小写
    
    int result = sqlite3_exec(db, insertString.UTF8String, NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        NSLog(@"插入成功");
        
        
        
    }else{
        NSLog(@"插入失败，错误操作数为%d",result);
    }
    [self closeDB];
    

}

// 删除
-(void)delelteModelByID:(NSInteger)LiwiuID{
    
    [self openDB];
    
    NSString *deleteString = [NSString stringWithFormat:@"DELETE FROM favorite where ID = '%ld'",LiwiuID];
    
    int result = sqlite3_exec(db, [deleteString UTF8String], NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败，错误操作数为%d",result);
    }
    [self closeDB];
}

// 查询所有用户
-(NSArray *)selectAllLiwu{
    
    [self openDB];
    //准备数组
    NSMutableArray *array = nil;
    //准备伴随指针
    sqlite3_stmt *stmt = nil;
    //准备SQL语句
    NSString *selectString = @"select *from favorite";
    
    int result = sqlite3_prepare_v2(db, [selectString UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        array = [[NSMutableArray alloc] initWithCapacity:20];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            LiWu *lw = [LiWu new];
            lw.ID = sqlite3_column_int(stmt, 0);
            lw.content_url = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            lw.cover_image_url = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            lw.share_msg = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            lw.title = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            
            [array addObject:lw];
            NSLog(@"收藏成功");
        }
    }else{
        NSLog(@"查询失败，失败操作数为%d",result);
    }
    //释放伴随指针
    sqlite3_finalize(stmt);
    
    
    for (LiWu *lw in array) {
        NSLog(@"%@",lw);
    }
    [self closeDB];
    
    return array;
}



@end
