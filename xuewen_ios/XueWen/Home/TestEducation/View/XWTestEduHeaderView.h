//
//  XWTestEduHeaderView.h
//  XueWen
//
//  Created by aaron on 2018/10/18.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XWTestEduHeaderViewDelegate <NSObject>

@optional

- (void)push;

@end

@interface XWTestEduHeaderView : UIView

@property (nonatomic,weak) id <XWTestEduHeaderViewDelegate> delegate;

@property (nonatomic,strong) UILabel * desLabel;

@end

NS_ASSUME_NONNULL_END
