//
//  XWDepartmentCell.h
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWDepartmentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWDepartmentCell : UITableViewCell

@property (nonatomic, strong) XWChildrenDepartmentModel *model;

@end

NS_ASSUME_NONNULL_END
