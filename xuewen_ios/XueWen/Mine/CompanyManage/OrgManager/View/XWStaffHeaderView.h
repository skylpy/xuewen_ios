//
//  XWStaffHeaderView.h
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWStaffInfoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZenBtnBlock)(void);

@interface XWStaffHeaderView : UIView

@property (nonatomic, strong) XWStaffInfoModel *model;

@property (nonatomic, copy) ZenBtnBlock block;

@end

NS_ASSUME_NONNULL_END
