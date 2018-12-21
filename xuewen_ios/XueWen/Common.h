//
//  Common.h
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#ifndef Common_h
#define Common_h
/** 通知 **/
#define PersonalInformationUpdate   @"PersonalInformationUpdate"        // 个人信息更新
#define applePaySucceed   @"applePaySucceed"        // 苹果支付成功
#define PaySucceed                  @"PaySucceed"                       // 支付成功
#define PayFailure                  @"PayFailure"                       // 支付失败
#define NotiExamAction              @"ExamAction"                       // 去考试
#define PushNotification            @"PushNotification"                 // 程序跳转通知
#define OrderListUpdate             @"OrderListUpdate"                  // 订单列表更新了
                 // 通知音频播放的上一次观看时间
#define TabbarDoubleHome            @"TabbarDoubleHome"                 // 首页双击了tabbar
#define TabbarDoubleCollect         @"TabbarDoubleCollect"              // 商学院双击tabbar

#define CollectionCourse      @"CollectionCourse"//　收藏课程


#define Succeed @"Succeed"

#define IsSucceed [status isEqualToString:@"Succeed"]

#define SetValue(value) (value.length > 0 )?value:@""

#define kUserInfo           [XWInstance shareInstance].userInfo

#define CellID              @"CellID"

// 过期提醒
#define kDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

/** WeakSelf */
#define WeakSelf              __weak typeof(self) weakSelf = self
#define XWWeakSelf            __weak typeof(self) weakSelf = self;
/** 判断字符串是否为空*/
#define IsEmptyString(str) (([str isKindOfClass:[NSNull class]] || str == nil || [str length]<=0)? YES : NO )

/** 系统版本*/
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/** 判断系统版本是否大于某（含）版本 */
#define IsLaterVersion(version) (([[[UIDevice currentDevice] systemVersion] floatValue] >= version)? 1:0)

/** 加载本地图片 */
#define LoadImage(imageName) [UIImage imageNamed:imageName]

/** 默认图片*/
#define DefaultImage LoadImage(@"default_cover")

/** 默认男头像*/
#define DefaultImageBoy LoadImage(@"boy")

/** 默认女头像*/
#define DefaultImageGril LoadImage(@"girl")

/** 判断本机是否是iPhone X */
#define IsIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/** 屏幕宽高*/
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define KScale kHeight/667

#define kStasusBarH     (IsIPhoneX ? 44.0 : 20.0)
#define kNaviBarH       (IsIPhoneX ? 88.0 : 64.0)
#define kTabBarH        (IsIPhoneX ? 83.0 : 49.0)
#define kBottomH        (IsIPhoneX ? 34.0 : 0.0)

#define kHeightNoNaviBar            kHeight - kNaviBarH
#define kHeightNoNaviBarNoTabBar    kHeight - kNaviBarH - kTabBarH

#define tableViewFrame              CGRectMake(0, 0, kWidth, kHeight - kNaviBarH - kBottomH)

#define ParmDict                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

/** 输出中文*/
#ifdef DEBUG
#define XWNSLog(FORMAT, ...) fprintf(stderr,"%s__Line%d: %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
#else
#define XWNSLog(...) {}
#endif

/*** 沙盒路径 ***/
#define DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]

#define IOS_VERSION_9_OR_LATER IsLaterVersion(9.0)

//#ifdef IOS_VERSION_9_OR_LATER

#define kRegFont             @"PingFangSC-Regular"
#define kMedFont             @"PingFangSC-Medium"
#define kSemFont             @"PingFangSC-Semibold"
#define kHeaFont             @"PingFangSC-Heavy"


#define XWFont(font,value)             [UIFont fontWithName:font size:(value*KScale)]

//#else
//
//#define kRegFont             @"HelveticaNeue-Thin"
//#define kMedFont             @"HelveticaNeue-Medium"
//
//#endif

/** 字号 */
#define kFontSize(size)     [UIFont systemFontOfSize:size]

/** 颜色相关 */
#define COLOR(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define ColorA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define COLORPercent(R,G,B) [UIColor colorWithRed:R green:G blue:B alpha:1.0]
#define Color(hexStr)  [UIColor colorWithHexString:hexStr]

//字体颜色

#define DefaultTitleAColor   (COLOR(51, 51, 51))
#define DefaultTitleBColor   (COLOR(102, 102, 102))
#define DefaultTitleCColor   (COLOR(153, 153, 153))
#define DefaultTitleDColor   (COLOR(204,204,204))

#define DefaultAlertColor    (Color(@"#3366FF"))

// 占位颜色
#define kCustomColor (COLOR(247,247,247))

/** 默认颜色 */
// App蓝色主色调 RGB 71 110 255
#define kThemeColor      (COLOR(71,110,255))

//橙色
#define DefaultOrangeColor     (COLOR(255,122,52))

// 背景色
#define DefaultGrayColor      ColorA(204, 208, 225, 0.2)

#define DefaultBgColor      (COLOR(247,247,247))

#define DefaultSepratorColor      (COLOR(238,238,238))

//已读字体颜色
#define DefaultReadColor   (COLOR(168,178,202))

//默认控件边框颜色、宽度、圆角
#define DefaultBorderColor COLOR(215.0, 215.0, 215.0)
#define DefaultBorderWidth 0.6f
#define DefaultRadius 6.0f

/** 16进制数值颜色 */ // 调用 ：HEXRGB(0XFFFFFF)
#define HEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 随机颜色 */
#define RandColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0]

/** keyWindow */
#define kMainWindow  [UIApplication sharedApplication].keyWindow

/** 根视图 */
#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

/** 请求方式 **/
#define Get                 @"GET"
#define Post                @"POST"
#define Put                 @"PUT"
#define Delete              @"DELETE"

#endif /* Common_h */
