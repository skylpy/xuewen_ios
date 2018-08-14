//
//  XWCollegeCollectionCell.h
//  XueWen
//
//  Created by Karron Su on 2018/4/26.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCourseLabelModel.h"

@interface XWCollegeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) XWCourseLabelModel *labelModel;

@property (nonatomic, strong) UIColor *bgColor;

@end
