//
//  XWIntroduceBuyView.h
//  XueWen
//
//  Created by ShaJin on 2018/1/10.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWIntroduceBuyView : UIView

@property (nonatomic, strong) NSString *price;

+ (instancetype)buyViewWithTarget:(id)target buyAction:(SEL)buyAction learnAction:(SEL)learnAction;

@end
