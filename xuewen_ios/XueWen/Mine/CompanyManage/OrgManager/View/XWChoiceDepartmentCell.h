//
//  XWChoiceDepartmentCell.h
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWLabelModel.h"
@class XWChildrenDepartmentModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^NextBlock)(XWChildrenDepartmentModel *model);

@interface XWChoiceDepartmentCell : UITableViewCell

@property (nonatomic, assign) BOOL isLabel;
@property (nonatomic, strong) XWLabelModel *model;
@property (nonatomic, strong) XWChildrenDepartmentModel *department;
@property (nonatomic, copy) NextBlock block;
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
