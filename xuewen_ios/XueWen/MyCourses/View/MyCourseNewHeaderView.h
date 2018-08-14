//
//  MyCourseNewHeaderView.h
//  XueWen
//
//  Created by ShaJin on 2017/12/25.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCourseNewHeaderView : UICollectionReusableView

- (void)addTarget:(id)target detailAction:(SEL)detailAction learningAction:(SEL)learningAction continueAction:(SEL)continueAction totalAction:(SEL)totalAction;
- (void)refresh;

@end
