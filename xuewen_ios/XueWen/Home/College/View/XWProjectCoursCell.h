//
//  XWProjectCoursCell.h
//  XueWen
//
//  Created by Karron Su on 2018/8/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

@interface XWProjectCoursCell : UITableViewCell

@property (nonatomic, strong) NSArray * dataSoure;
@property (nonatomic, strong) ProjectModel *model;
@property (nonatomic, assign) BOOL buy;

@end
