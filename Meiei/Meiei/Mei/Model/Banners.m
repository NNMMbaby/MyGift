//
//  Banners.m
//  Meiei
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 南南南. All rights reserved.
//

#import "Banners.h"

@implementation Banners

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = [value intValue];
    }
}




@end
