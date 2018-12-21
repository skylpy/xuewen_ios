//
//  XWIncomeListHeaderView.h
//  XueWen
//
//  Created by Karron Su on 2018/9/10.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XWIncomeListHeaderViewDelegate <NSObject>

- (void)datePickShow;

@end

@interface XWIncomeListHeaderView : UIView

@property (nonatomic, weak) id<XWIncomeListHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSString *earnings;

@end
