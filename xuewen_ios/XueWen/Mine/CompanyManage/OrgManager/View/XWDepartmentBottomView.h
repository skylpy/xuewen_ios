//
//  XWDepartmentBottomView.h
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LeftBtnBlock)(void);
typedef void(^MidBtnBlock)(void);
typedef void(^RightBtnBlock)(void);

@interface XWDepartmentBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@property (nonatomic, copy) LeftBtnBlock leftBlock;
@property (nonatomic, copy) MidBtnBlock midBlock;
@property (nonatomic, copy) RightBtnBlock rightBlock;

@end

NS_ASSUME_NONNULL_END
