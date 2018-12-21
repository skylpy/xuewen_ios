//
//  XWCompanyModel.m
//  XueWen
//
//  Created by ShaJin on 2017/11/23.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWCompanyModel.h"

@implementation XWCompanyModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"oid" : @"id",
             @"name" : @"co_name",
             @"phoneNumber" : @"co_number",
             @"addres" : @"co_addres",
             @"contacts" : @"co_contacts",
             @"introduction" : @"co_introduction",
             @"collegeName" : @"college_name",
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.oid           forKey:@"oid"];
    [aCoder encodeObject:self.name          forKey:@"name"];
    [aCoder encodeObject:self.phoneNumber   forKey:@"phoneNumber"];
    [aCoder encodeObject:self.addres        forKey:@"addres"];
    [aCoder encodeObject:self.contacts      forKey:@"contacts"];
    [aCoder encodeObject:self.introduction  forKey:@"introduction"];
    [aCoder encodeObject:self.collegeName   forKey:@"collegeName"];
    [aCoder encodeObject:self.co_picture_all    forKey:@"co_picture_all"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.oid =              [aDecoder decodeObjectForKey:@"oid"];
        self.name =             [aDecoder decodeObjectForKey:@"name"];
        self.phoneNumber =      [aDecoder decodeObjectForKey:@"phoneNumber"];
        self.addres =           [aDecoder decodeObjectForKey:@"addres"];
        self.contacts =         [aDecoder decodeObjectForKey:@"contacts"];
        self.introduction =     [aDecoder decodeObjectForKey:@"introduction"];
        self.collegeName =      [aDecoder decodeObjectForKey:@"collegeName"];
        self.co_picture_all =   [aDecoder decodeObjectForKey:@"co_picture_all"];
    }
    return self;
}
@end
