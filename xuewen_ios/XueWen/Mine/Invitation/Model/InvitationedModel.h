//
//  InvitationedModel.h
//  XueWen
//
//  Created by ShaJin on 2018/3/9.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>

//er_id    邀请人id    是    [string]    73    查看
//invite_user_phone    邀请人手机号    是    [string]    13049628162    查看
//invited_user_id    被邀请人id    是    [string]    270    查看
//invited_user_phone    被邀请人手机号    是    [string]    130****8164    查看
//create_time    时间    是    [string]    1520506226

@interface InvitationedModel : NSObject
/** 邀请人ID */
@property (nonatomic, strong) NSString *inviteID;
/** 邀请人手机号 */
@property (nonatomic, strong) NSString *invitePhone;
/** 被邀请人ID */
@property (nonatomic, strong) NSString *invitedID;
/** 被邀请人手机号 */
@property (nonatomic, strong) NSString *invitedPhone;
/** 被邀请人昵称 */
@property (nonatomic, strong) NSString *invitedNickName;
/** 被邀请人姓名 */
@property (nonatomic, strong) NSString *invitedName;
/** 被邀请人公司名 */
@property (nonatomic, strong) NSString *invitedCompanyName;
/** 被邀请人账号注册时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 邀请状态 */
@property (nonatomic, strong) NSString *status;
/** 充值金额 */
@property (nonatomic, strong) NSString *money;
/** 注册数 */
@property (nonatomic, strong) NSString *registCount;
/** 激活数 */
@property (nonatomic, strong) NSString *activeCount;
/**  是否显示全部信息 */
@property (nonatomic, assign) BOOL showAll;

@end
@interface InvitationPersonalModel : NSObject
/** 邀请人ID */
@property (nonatomic, strong) NSString *inviteID;
/** 邀请人手机号 */
@property (nonatomic, strong) NSString *invitePhone;
/** 被邀请人ID */
@property (nonatomic, strong) NSString *invitedID;
/** 被邀请人手机号 */
@property (nonatomic, strong) NSString *invitedPhone;
/** 被邀请人账号注册时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 邀请状态 */
@property (nonatomic, strong) NSString *status;
@end
