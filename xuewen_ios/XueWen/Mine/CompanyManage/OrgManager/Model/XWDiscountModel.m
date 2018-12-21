//
//  XWDiscountModel.m
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDiscountModel.h"

@implementation XWDiscountModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"couponId" : @"id"};
}

@end
