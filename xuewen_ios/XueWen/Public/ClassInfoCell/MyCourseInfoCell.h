//
//  MyCourseInfoCell.h
//  XueWen
//
//  Created by ShaJin on 2017/12/11.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseModel;
@interface MyCourseInfoCell : UICollectionViewCell
/** 以后改用setModel:showProgress方法 show：是否显示进度 */
@property (nonatomic, strong) CourseModel *model kDeprecated("改用setModel:showProgress方法");
/** 以后改用这个方法设置model 2018.01.15 show：是否显示进度 */
- (void)setModel:(CourseModel *)model showProgress:(BOOL)show;
@end
