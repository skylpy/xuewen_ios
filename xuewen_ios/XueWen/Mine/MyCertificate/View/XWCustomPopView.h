//
//  XWCustomPopView.h
//  XueWen
//
//  Created by aaron on 2018/8/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWCustomPopView : UIView

+ (instancetype)shareCustomNew ;

- (void)showFoemSuperView:(UIView *)superView withTitle:(NSString *)title withExamClick:(void (^)(void))examClick ;

@end
