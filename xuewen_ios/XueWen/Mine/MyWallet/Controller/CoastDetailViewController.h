//
//  CoastDetailViewController.h
//  XueWen
//
//  Created by Pingzi on 2017/12/8.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CoastIn,  //充值
    CoastOut, //消费
} CoastType;

@interface CoastDetailViewController : UIViewController

@property (nonatomic, assign) CoastType type;
@end
