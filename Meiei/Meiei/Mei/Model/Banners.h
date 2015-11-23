//
//  Banners.h
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banners : NSObject

@property (nonatomic, strong)NSString * channel;
@property (nonatomic, assign)NSInteger  ID;
@property (nonatomic, strong)NSString * image_url;
@property (nonatomic, assign)NSInteger  order;
@property (nonatomic, assign)NSInteger  status;
@property (nonatomic, strong)NSString * target_id;
@property (nonatomic, strong)NSString * target_url;
@property (nonatomic, strong)NSString * type;
@property (nonatomic, strong)NSDictionary * target;


@end
