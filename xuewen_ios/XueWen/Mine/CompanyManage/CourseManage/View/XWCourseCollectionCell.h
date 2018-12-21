//
//  XWCourseCollectionCell.h
//  XueWen
//
//  Created by aaron on 2018/12/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCourseManageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XWCourseCollectionCell : UITableViewCell

@property (nonatomic,strong) XWCourseManageModel * model;

@property (nonatomic,copy) void (^purchaseClick)(NSString * courseId);


@end

NS_ASSUME_NONNULL_END
