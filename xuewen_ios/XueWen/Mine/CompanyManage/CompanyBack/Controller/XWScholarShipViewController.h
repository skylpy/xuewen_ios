//
//  XWScholarShipViewController.h
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWScholarShipViewController : XWBaseViewController

@property (nonatomic,copy) void (^ScholarShipClick)(CGFloat totle,NSInteger index,NSString * couponID);

@property (nonatomic,assign) CGFloat shipPrice;
@property (nonatomic,copy) NSString * couponID;


@end

NS_ASSUME_NONNULL_END
