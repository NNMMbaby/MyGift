//
//  LiWu.m
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "LiWu.h"

#define kID @"ID"
#define kContent_url @"content_url"
#define kCover_img_url @"cover_image_url"
#define kShare_msg @"share_msg"
#define kTitle @"title"


@implementation LiWu


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        _ID = [value integerValue];
    }
    }



@end
