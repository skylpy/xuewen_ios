//
//  XWRecordsCell.h
//  XueWen
//
//  Created by aaron on 2018/7/28.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface XWRecordsCell : UITableViewCell

@property (nonatomic,strong) CourseModel * model;

@property (nonatomic,copy) NSArray * array;

@property (nonatomic,copy) void (^recordsClick)(NSString *cid, BOOL isAudio);

@end
