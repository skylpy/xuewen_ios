//
//  InvitationedModel.m
//  XueWen
//
//  Created by ShaJin on 2018/3/9.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "InvitationedModel.h"

@implementation InvitationedModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"inviteID"        : @"i_id",
             @"invitePhone"     : @"referee_phone",
             @"invitedID"       : @"id",
             @"invitedPhone"    : @"phone",
             @"creatTime"       : @"create_time",
             @"invitedNickName" : @"nick_name",
             @"invitedName"     : @"name",
             @"invitedCompanyName" : @"co_name",
             @"money"           : @"amount",
             @"registCount"     : @"register",
             @"activeCount"     : @"activation",
             };
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [creatTime stringWithDataFormatter:@"yyyy-MM-dd"];
}

- (NSString *)status{
    return @"已邀请";
}

@end
@implementation InvitationPersonalModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"inviteID"        : @"invite_user_id",
             @"invitePhone"     : @"invite_user_phone",
             @"invitedID"       : @"invited_user_id",
             @"invitedPhone"    : @"invited_user_phone",
             @"creatTime"       : @"create_time"
             };
}

- (void)setCreatTime:(NSString *)creatTime{
    _creatTime = [creatTime stringWithDataFormatter:@"yyyy-MM-dd"];
}

- (NSString *)status{
    return @"已邀请";
}

@end

