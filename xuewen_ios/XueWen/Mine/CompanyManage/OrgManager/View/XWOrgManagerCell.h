//
//  XWOrgManagerCell.h
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWOrgManagerModel.h"
#import "XWDepartmentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XWOrgManagerCell : UITableViewCell

@property (nonatomic, strong) XWOrgManagerModel *model;

@property (nonatomic, assign) BOOL isDepartment;

@property (nonatomic, assign) BOOL isHome;

@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, strong) XWDepartmentUserModel *user;

@end


NS_ASSUME_NONNULL_END
