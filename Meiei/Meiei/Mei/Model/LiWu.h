//
//  LiWu.h
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiWu : NSObject

//@property (nonatomic, strong)NSString *ID;
@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, strong)NSString *content_url;
@property (nonatomic, strong)NSString *cover_image_url;
@property (nonatomic, strong)NSString *share_msg;
@property (nonatomic, strong)NSString *title;


/*
@property (nonatomic, strong)NSString *liked;
@property (nonatomic, assign)NSInteger likes_count;

@property (nonatomic, strong)NSString *created_at;
@property (nonatomic, strong)NSString *editor_id;
@property (nonatomic, strong)NSString *published_at;

@property (nonatomic, strong)NSString *short_title;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *temp_late;
@property (nonatomic, strong)NSString *type;

@property (nonatomic, strong)NSString *updated_at;
@property (nonatomic, strong)NSString *url;
 
#define kLike @"liked"
#define kLike_count @"likes_count"
#define kCreat @"created_at"
#define kEditor_id @"editor_id"
#define kPublish @"published_at"
#define kShort_title @"short_title"

#define kLabels @"labels"
#define kStatus @"status"
#define kTemp @"temp_late"
#define kType @"type"
#define kUpdate @"updated_at"

#define kURL @"url"

*/


@end
