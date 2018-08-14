//
//  PayStatusVC.h
//  XueWen
//
//  Created by Pingzi on 2017/12/8.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PaySuccess,
    PayFail,
} PayStatus;

@interface PayStatusVC : UIViewController

@property (nonatomic, assign) PayStatus status;

@end
