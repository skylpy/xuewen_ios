//
//  XWBuyView.h
//  XueWen
//
//  Created by ShaJin on 2018/1/22.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWBuyView : UIView
- (instancetype)initWithPrice:(NSString *)price target:(id)target buyAction:(SEL)buyAction learnAction:(SEL)learnAction pack:(BOOL)pack;
@end
