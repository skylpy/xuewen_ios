//
//  XWChoiceDepartmentViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"

@class XWChildrenDepartmentModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChoiceDepartmentBlock)(XWChildrenDepartmentModel *model);

@interface XWChoiceDepartmentViewController : XWBaseViewController

@property (nonatomic, copy) ChoiceDepartmentBlock block;

@end

NS_ASSUME_NONNULL_END
