//
//  XWDepartmentTitleView.h
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWChildrenDepartmentModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^BtnCLickBlock)(XWChildrenDepartmentModel *child);

@interface XWDepartmentTitleView : UIView

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, copy) BtnCLickBlock block;

@end

NS_ASSUME_NONNULL_END
