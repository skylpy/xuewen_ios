//
//  XWInstance.m
//  XueWen
//
//  Created by ShaJin on 2017/11/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWInstance.h"
#import "HSDeviceIdentifier.h"
#import "sys/utsname.h"
#import "NSString+AES128.h"
#import "CourseModel.h"
#import "MainNavigationViewController.h"
#import "LoginViewController.h"
#import "XWWebSocket.h"
static XWInstance *instance = nil;
@interface XWInstance()
{
    XWUserInfo  *_userInfo;
    XWGeneral   *_general;
    NSString    *_accessToken;
    NSString    *_invitationURL;
    BOOL        _isTest;
    NSString    *_collegeName;
    NSArray<CourseLabelModel *> *_courseLabelList;
}
@end
@implementation XWInstance
/** 注销账号 */
- (void)logout{
    XWInstance *instance = [XWInstance shareInstance] ;
    instance.accessToken = nil;
    instance.userInfo = nil;
    LoginViewController *vc = [LoginViewController new];
    MainNavigationViewController *navi = [[MainNavigationViewController alloc]initWithRootViewController:vc];
    [[UIViewController getCurrentVC] presentViewController:navi animated:YES completion:nil];
    
}
#pragma mark- Getter
- (NSString *)url{

    // 测试环境
    return @"http://api.st.52xuewen.com/";

    
    // 正式环境
//    return @"http://xwapi.52xuewen.com/";
 
//    return self.isTest ? @"http://api.st.52xuewen.com/" : @"http://xwapi.52xuewen.com/";
}

- (NSString *)invitationURL{
    @synchronized(self) {
        if (!_invitationURL) {
            _invitationURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"invitationURL"];
        }
    }
    return _invitationURL;
}

- (BOOL)isTest{
    @synchronized(self) {
        if (!_isTest) {
            _isTest = [[NSUserDefaults standardUserDefaults] boolForKey:@"isTest"];
        }
    }
    return _isTest;
}

- (XWUserInfo *)userInfo{
    @synchronized(self) {
        if (!_userInfo) {
            NSData *userdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            _userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
        }
    }
    return _userInfo;
}

- (XWGeneral *)general {
    @synchronized(self) {
        if (!_general) {
            _general = [self creatGeneralInfo];
        }
    }
    return _general;
}

- (NSString *)accessToken{
    @synchronized (self) {
        if (!_accessToken) {
            _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
        }
    }
    return _accessToken;
}

- (NSString *)collegeName{
    @synchronized (self) {
        if (!_collegeName) {
            _collegeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"collegeName"];
        }
    }
    return _collegeName;
}

/** 获取签名信息 */
- (NSString *)getSignWith:(NSString *)time{
    return [NSString encryptWithAppType:self.general.appType did:self.general.deviceID time:time];
}

- (NSArray<CourseLabelModel *> *)courseLabelList{
    @synchronized (self) {
        if (!_courseLabelList) {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"courseLabelList"];
            _courseLabelList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _courseLabelList;
}

#pragma mark- Setter
- (void)setCollegeName:(NSString *)collegeName{
    if (![_collegeName isEqualToString:collegeName]) {
        _collegeName = collegeName;
        [[NSUserDefaults standardUserDefaults] setObject:collegeName forKey:@"collegeName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setInvitationURL:(NSString *)invitationURL{
    if (![_invitationURL isEqualToString:invitationURL]) {
        _invitationURL = invitationURL;
        [[NSUserDefaults standardUserDefaults] setObject:invitationURL forKey:@"invitationURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setIsTest:(BOOL)isTest{
    if (_isTest != isTest) {
        _isTest = isTest;
        [[NSUserDefaults standardUserDefaults] setBool:isTest forKey:@"isTest"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *message = [NSString stringWithFormat:@"接口切换为：%@",isTest ? @"测试接口" : @"线上接口"];
        [XWPopupWindow popupWindowsWithTitle:@"提示" message:message buttonTitle:@"好的" buttonBlock:nil];
    }
}

- (void)setUserInfo:(XWUserInfo *)userInfo{
    if (_userInfo != userInfo) {
        _userInfo = userInfo;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setAccessToken:(NSString *)accessToken{
    if (![_accessToken isEqualToString:accessToken]) {
        _accessToken = accessToken;
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[XWWebSocket shareInstance] logout];
        if (accessToken){
            [[XWWebSocket shareInstance] login];
        }
    }
}

- (void)setCourseLabelList:(NSArray<CourseLabelModel *> *)courseLabelList{
    _courseLabelList = courseLabelList;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"courseLabelList"];
    NSData *courseData = [NSKeyedArchiver archivedDataWithRootObject:_courseLabelList];
    if (![data isEqualToData:courseData]) {
        [[NSUserDefaults standardUserDefaults] setObject:courseData forKey:@"courseLabelList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark- CustomMethod
- (XWGeneral *)creatGeneralInfo{
    XWGeneral *general = [XWGeneral new];
    general.appType = @"ios";
    general.deviceID = [HSDeviceIdentifier getUniqueIdentifier];
    general.deviceOs = [[UIDevice currentDevice] systemVersion];
    general.deviceType = [self getCurrentDeviceModel];

    return general;
}

//获取具体的手机型号iphone几
- (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (A1778)";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus(A1784)";
    
    return platform;
}

#pragma mark- onceToken  初始化
+ (instancetype) shareInstance{
    @synchronized (self) {
        if (instance == nil) {
            return [[self alloc] init];
        }
    }
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        
    });
    return instance;
}
@end
