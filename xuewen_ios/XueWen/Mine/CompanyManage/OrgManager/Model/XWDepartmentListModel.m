//
//  XWDepartmentModel.m
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWDepartmentListModel.h"


@implementation XWChildrenDepartmentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"oid" : @"id"};
}

@end

@implementation XWDepartmentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"children" : [XWChildrenDepartmentModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"oid" : @"id"};
}

@end

@implementation XWDepartmentUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id"};
}

@end

@implementation XWDepartmentListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"depeparList" : [XWDepartmentModel class],
             @"userList" : [XWDepartmentUserModel class],
             @"Department" : [XWChildrenDepartmentModel class]
             };
}


@end
