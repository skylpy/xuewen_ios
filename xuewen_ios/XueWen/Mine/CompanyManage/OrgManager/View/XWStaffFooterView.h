//
//  XWStaffFooterView.h
//  XueWen
//
//  Created by Karron Su on 2018/12/13.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RemoveStaffBlock)(void);
@interface XWStaffFooterView : UIView

@property (nonatomic, copy) RemoveStaffBlock block;

@end

NS_ASSUME_NONNULL_END
