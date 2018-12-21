//
//  XWBannerEditViewController.h
//  XueWen
//
//  Created by Karron Su on 2018/12/11.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import "XWBaseViewController.h"
#import "BannerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ControllerTypeAdd,
    ControllerTypeEdit,
} ControllerType;

@interface XWBannerEditViewController : XWBaseViewController

@property (nonatomic, assign) ControllerType type;
@property (nonatomic, strong) BannerModel *banner;

@end

NS_ASSUME_NONNULL_END
