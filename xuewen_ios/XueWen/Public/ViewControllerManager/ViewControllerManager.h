//
//  ViewControllerManager.h
//  XueWen
//
//  Created by ShaJin on 2018/1/29.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerManager : NSObject
/** 课程详情界面 */
+ (UIViewController *)detailViewControllerWithCourseID:(NSString *)courseID;
/** 我的钱包界面 */
+ (UIViewController *)WalletViewController;
/** 支付订单界面 */
+ (UIViewController *)orderInfoWithID:(NSString *)identifier type:(int)type updateBlock:(void(^)(void))updateBlock;
/** 测试界面，只有测试账号才能看到这个界面*/
+ (UIViewController *)debugViewController;


/** 新版课程详情界面*/
+ (UIViewController *)detailViewControllerWithCourseID:(NSString *)courseID isAudio:(BOOL)isAudio;
@end
