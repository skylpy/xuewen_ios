//
//  XWBalanceView.h
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWBalancesView : UIView

+ (instancetype)shareBalanceView ;
@property (nonatomic,copy) void (^balancesClick)(NSString * o_id);

@end

NS_ASSUME_NONNULL_END
