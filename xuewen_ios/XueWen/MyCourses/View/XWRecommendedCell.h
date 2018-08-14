//
//  XWRecommendedCell.h
//  XueWen
//
//  Created by aaron on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@protocol XWRecommendedCellDelegate <NSObject>
@optional
- (void)recommendedCellDidSelect:(CourseModel *)model;

@end

@interface XWRecommendedCell : UITableViewCell

@property (nonatomic,copy) NSArray * dataSoure;
@property (nonatomic,weak) id <XWRecommendedCellDelegate> delegate;

@end
