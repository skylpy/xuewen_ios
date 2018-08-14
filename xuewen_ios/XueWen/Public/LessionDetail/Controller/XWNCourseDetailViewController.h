//
//  XWNCourseDetailViewController.h
//  XueWen
//
//  Created by aaron on 2018/7/16.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "ENestScrollPageView.h"
#import "XWCoursInfoModel.h"


@interface XWNCourseDetailViewController : XWBaseViewController

- (instancetype)initWithCourseID:(NSString *)courseID isAudio:(BOOL)isAudio;

@end

