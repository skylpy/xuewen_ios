//
//  ViewControllerManager.m
//  XueWen
//
//  Created by ShaJin on 2018/1/29.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "ViewControllerManager.h"
#import "MyWalletViewController.h"
#import "ConfirmOrderViewController.h"
#import "DebugViewController.h"
#import "XWCourseDetailViewController.h"
#import "XWNCourseDetailViewController.h"

@implementation ViewControllerManager

+ (UIViewController *)WalletViewController{
    return [MyWalletViewController new];
}

+ (UIViewController *)orderInfoWithID:(NSString *)identifier type:(int)type updateBlock:(void (^)(void))updateBlock{
    return [[ConfirmOrderViewController alloc] initWithID:identifier type:type updateBlcok:updateBlock];
}

+ (UIViewController *)debugViewController{
    return [DebugViewController new];
}

/** 新版课程详情界面*/
+ (UIViewController *)detailViewControllerWithCourseID:(NSString *)courseID isAudio:(BOOL)isAudio{
    
    return [[XWNCourseDetailViewController alloc] initWithCourseID:courseID isAudio:isAudio];
//    return [[XWCourseDetailViewController alloc] initWithCourseID:courseID isAudio:isAudio];
}

@end
