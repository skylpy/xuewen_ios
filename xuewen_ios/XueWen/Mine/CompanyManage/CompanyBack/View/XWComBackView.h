//
//  XWCompanyBackView.h
//  XueWen
//
//  Created by aaron on 2018/12/11.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWComBackView : UIView

+ (instancetype)shareCompanyBackView;

@property (nonatomic,copy) void (^rechargeClick)(void);


@end

NS_ASSUME_NONNULL_END
