//
//  XWSelectTableCell.h
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWDepartmentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWSelectTableCell : UITableViewCell

@property (nonatomic, assign) BOOL hideRight;

@property (nonatomic, strong) XWChildrenDepartmentModel *children;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *departmentName;

@end


NS_ASSUME_NONNULL_END
