//
//  XWUserInfo.m
//  XueWen
//
//  Created by ShaJin on 2017/11/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWUserInfo.h"

@implementation XWUserInfo
- (void)setSex:(NSString *)sex{
    if ([sex isEqualToString:@"0"]) {
        _sex = @"女";
    }else if([sex isEqualToString:@"1"]){
        _sex = @"男";
    }else{
        _sex = sex;
    }
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"oid"     : @"id",
             @"company" : @"profile",
             @"picture" : @"picture_all",
             @"label_id": @"lable_id",
             @"n_role_id" : @"new_role_id"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"company" : @"XWCompanyModel"};
}

- (void)setRole_id:(NSString *)role_id {
    _role_id = role_id;
    _personal = [role_id isEqualToString:@"3"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.oid               forKey:@"oid"];
    [aCoder encodeObject:self.role_id           forKey:@"role_id"];
    [aCoder encodeObject:self.n_role_id         forKey:@"n_role_id"];
    [aCoder encodeObject:self.department_id     forKey:@"department_id"];
    [aCoder encodeObject:self.account           forKey:@"account"];
    [aCoder encodeObject:self.company_id        forKey:@"company_id"];
    [aCoder encodeObject:self.status            forKey:@"status"];
    [aCoder encodeObject:self.pid               forKey:@"pid"];
    [aCoder encodeObject:self.gold              forKey:@"gold"];
    [aCoder encodeObject:self.earnings_price    forKey:@"earnings_price"];
    [aCoder encodeObject:self.create_time       forKey:@"create_time"];
    [aCoder encodeObject:self.phone             forKey:@"phone"];
    [aCoder encodeObject:self.name              forKey:@"name"];
    [aCoder encodeObject:self.picture           forKey:@"picture"];
    [aCoder encodeObject:self.nick_name         forKey:@"nick_name"];
    [aCoder encodeObject:self.sex               forKey:@"sex"];
    [aCoder encodeObject:self.birthday          forKey:@"birthday"];
    [aCoder encodeObject:self.province          forKey:@"province"];
    [aCoder encodeObject:self.area              forKey:@"area"];
    [aCoder encodeObject:self.county            forKey:@"county"];
    [aCoder encodeObject:self.region_name       forKey:@"region_name"];
    [aCoder encodeObject:self.last_login_time   forKey:@"last_login_time"];
    [aCoder encodeObject:self.introduction      forKey:@"introduction"];
    [aCoder encodeObject:self.company           forKey:@"company"];
    [aCoder encodeObject:self.label_id          forKey:@"label_id"];
    [aCoder encodeBool:self.personal            forKey:@"personal"];
    [aCoder encodeObject:self.company_status    forKey:@"company_status"];
    [aCoder encodeObject:self.company_gold    forKey:@"company_gold"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.oid =              [aDecoder decodeObjectForKey:@"oid"];
        self.role_id =          [aDecoder decodeObjectForKey:@"role_id"];
        self.n_role_id =        [aDecoder decodeObjectForKey:@"n_role_id"];
        self.department_id =    [aDecoder decodeObjectForKey:@"department_id"];
        self.account =          [aDecoder decodeObjectForKey:@"account"];
        self.company_id =       [aDecoder decodeObjectForKey:@"company_id"];
        self.status =           [aDecoder decodeObjectForKey:@"status"];
        self.pid =              [aDecoder decodeObjectForKey:@"pid"];
        self.gold =             [aDecoder decodeObjectForKey:@"gold"];
        self.earnings_price =   [aDecoder decodeObjectForKey:@"earnings_price"];
        self.create_time =      [aDecoder decodeObjectForKey:@"create_time"];
        self.phone =            [aDecoder decodeObjectForKey:@"phone"];
        self.name =             [aDecoder decodeObjectForKey:@"name"];
        self.picture =          [aDecoder decodeObjectForKey:@"picture"];
        self.nick_name =        [aDecoder decodeObjectForKey:@"nick_name"];
        self.sex =              [aDecoder decodeObjectForKey:@"sex"];
        self.birthday =         [aDecoder decodeObjectForKey:@"birthday"];
        self.province =         [aDecoder decodeObjectForKey:@"province"];
        self.area =             [aDecoder decodeObjectForKey:@"area"];
        self.county =           [aDecoder decodeObjectForKey:@"county"];
        self.region_name =      [aDecoder decodeObjectForKey:@"region_name"];
        self.last_login_time =  [aDecoder decodeObjectForKey:@"last_login_time"];
        self.introduction =     [aDecoder decodeObjectForKey:@"introduction"];
        self.company =          [aDecoder decodeObjectForKey:@"company"];
        self.label_id =         [aDecoder decodeObjectForKey:@"label_id"];
        self.personal =         [aDecoder decodeBoolForKey:@"personal"];
        self.company_status =   [aDecoder decodeObjectForKey:@"company_status"];
        self.company_gold =   [aDecoder decodeObjectForKey:@"company_gold"];
    }
    return self;
}
@end
