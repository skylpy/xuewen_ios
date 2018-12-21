//
//  XWOrgManagerModel.m
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWOrgManagerModel.h"

@implementation XWOrgManagerModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID" : @"id",
             @"companyId" : @"company_id",
             @"pictureAll" : @"picture_all",
             @"roleName" : @"new_role_name"
             };
}

@end
