//
//  XWSelectCourseView.h
//  XueWen
//
//  Created by aaron on 2018/12/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWSelectCoursesView : UIView

+ (instancetype)showCourseView:(UIView *)superView withFrame:(CGRect)frame withCourseClick:(void (^)(NSString * labelID,NSString * labelName))courseClick;
@end

NS_ASSUME_NONNULL_END
