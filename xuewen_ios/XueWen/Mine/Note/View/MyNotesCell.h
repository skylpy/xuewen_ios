//
//  MyNotesCell.h
//  XueWen
//
//  Created by ShaJin on 2017/12/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseNoteModel;
@interface MyNotesCell : UITableViewCell

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) CourseNoteModel *model;

@end
