//
//  AreaModel.m
//  XueWen
//
//  Created by ShaJin on 2017/11/24.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "AreaModel.h"
@implementation AreaModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"areaID" : @"id"};
}

@end
@implementation CityModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"cityID" : @"id"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"districts" : @"AreaModel"};
}
@end
@implementation ProvinceModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"provinceID" : @"id"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"cities" : @"CityModel"};
}
@end
