//
//  XWOrgTwoBottomView.h
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LeftBtnBlock)(void);
typedef void(^RightBtnBlock)(void);

@interface XWOrgTwoBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArrays:(NSArray *)titles;

@property (nonatomic, copy) LeftBtnBlock leftBlock;
@property (nonatomic, copy) RightBtnBlock rightBlock;

@end

NS_ASSUME_NONNULL_END
