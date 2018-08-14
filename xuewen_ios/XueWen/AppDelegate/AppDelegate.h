//
//  AppDelegate.h
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedInstanced;

- (void)setSomeThing;

@end

