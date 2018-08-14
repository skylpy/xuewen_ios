//
//  ExamResultHeaderView.h
//  XueWen
//
//  Created by ShaJin on 2017/12/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ExamResultHeaderViewDelegate <NSObject>

- (void)retestAction;
- (void)continueAction;
- (void)errorAction;
- (void)hosAction;
- (void)shareAction;

@end

@interface ExamResultHeaderView : UICollectionReusableView

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, weak) id<ExamResultHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSString *comment;

@end
