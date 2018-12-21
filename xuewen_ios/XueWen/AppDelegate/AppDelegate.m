//
//  AppDelegate.m
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeTabController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "XWInstance.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayStatusVC.h"
#import "XWWebSocket.h"
#import "MainNavigationViewController.h"
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
#import "WXApi.h"
#import <AVFoundation/AVFoundation.h>
#import <Bugly/Bugly.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

+ (instancetype)sharedInstanced {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

// 锁屏界面控制监听
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    [[XWAudioInstanceController shareInstance] remoteControlReceivedWithEvent:event];
}
#pragma mark- 程序启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setSomeThing];
    return YES;
}

#pragma mark - 配置信息
- (void)setSomeThing {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    // 获取服务器时间
    [XWNetworking getServerTime];
    // 获取商学院名称
    [XWHttpTool getCollegeName];
    /*** 设置导航条统一风格 ***/
    [self setNaviBar];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 监听网络状态
    [self networkMonitor];
    
    // 设置键盘
    [self configKeyboardManager];
    // 登陆功能
    [self buildKeyWindow];
    // 设置OSS
    [XWNetworking setupOSSClient];
    // 检查系统版本
    [XWNetworking checkAppVersion];
    // 友盟
    [self setUMCAnalytics];
    // 微信
    [self setupWXapi];
    // bugly
    [Bugly startWithAppId:@"1a53db716e"];
}

#pragma mark- 回调接口
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    NSLog(@"url = %@ option = %@ host = %@",url.absoluteString,options,url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSString *resultStr = resultDic[@"result"];
            NSDictionary *dict = [NSDictionary dictionaryWithJsonString:resultStr];
            if ([dict[@"alipay_trade_app_pay_response"][@"msg"] isEqualToString:@"Success"]) {
                PayStatusVC *vc = [PayStatusVC new];
                vc.status = PaySuccess;
                [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:PaySucceed object:nil];
                
            }else{
                PayStatusVC *vc = [PayStatusVC new];
                vc.status = PayFail;
                [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:PayFailure object:nil];
            }
            
            [XWNetworking getAccountInfoWithCompletionBlock:nil];
        }];
    }else if ([url.absoluteString hasPrefix:@"wx"]){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
#pragma mark- 微信相关
- (void)setupWXapi{
    [WXApi registerApp:@"wx29c64388f7cd0d75"];
}
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void) onReq:(BaseReq*)req{
    NSLog(@"微信请求 type = %d openID = %@",req.type,req.openID);
}
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp 具体的回应内容，是自动释放的
 */
- (void) onResp:(BaseResp*)resp{
    NSLog(@"微信回调 错误码 = %d message = %@ type = %d",resp.errCode,resp.errStr,resp.type);
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                PayStatusVC *vc = [PayStatusVC new];
                vc.status = PaySuccess;
                [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:PaySucceed object:nil];
            }
                break;
                
            default:
            {
                PayStatusVC *vc = [PayStatusVC new];
                vc.status = PayFail;
                [[UIViewController getCurrentVC].navigationController pushViewController:vc animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:PayFailure object:nil];
            }
                break;
        }
    }
}
#pragma mark - --- 登陆功能 ---
- (void)buildKeyWindow{
    if ([XWInstance shareInstance].accessToken) {
        // 主界面
        self.window.rootViewController = [HomeTabController new];
        // 登陆websocket
        [[XWWebSocket shareInstance] login];
        // 更新课程标签列表
        [XWNetworking getCoursLabelListWithCompletionBlock:nil];
    }else{
        // 登陆界面
        self.window.rootViewController = [LoginViewController new];
    }
}

- (long long)getTotalMemorySize{
    return [NSProcessInfo processInfo].physicalMemory;
}

- (void)setNaviBar{
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = DefaultTitleAColor;
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:kRegFont size:18];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttrs];
}

#pragma mark - --- 键盘位移处理 ---

- (void)configKeyboardManager {
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
}

#pragma mark- 网络状态监听
- (void)networkMonitor{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [XWInstance shareInstance].general.networkType = status;
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"程序失去焦点");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    AppDelegate postNotificationWithName:<#(NSString *)#>
}

- (void)setUMCAnalytics{
//     配置友盟SDK产品并并统一初始化
//     [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
#ifdef DEBUG
    [UMConfigure setLogEnabled:YES]; // 开发调试时可在cons546ole查看友盟日志显示，发布产品必须移除。
#else
    [UMConfigure setLogEnabled:NO];
#endif
    
    [UMConfigure initWithAppkey:@"5aa8e329f43e4876e7000305" channel:@"App Store"];
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    
    
    
    
    
    // [MobClick setScenarioType:E_UM_GAME];  // optional: 游戏场景设置
    
    // Push组件基本功能配置
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//            // 用户选择了接收Push消息
//        }else{
//            // 用户拒绝接收Push消息
//        }
//    }];
    
    
    // 请参考「Share详细介绍-初始化第三方平台」
    // 分享组件配置，因为share模块配置可选三方平台较多，代码基本跟原版一样，也可下载demo查看
//    [self configUSharePlatforms];   // required: setting platforms on demand

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"程序进入后台");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"程序从后台回到前台");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"程序获取焦点");
    [[XWWebSocket shareInstance] login];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"程序即将退出");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSLog(@"程序内存警告，可能要终止程序");
}
@end
