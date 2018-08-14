//
//  ClassesHeaderView.h
//  XueWen
//
//  Created by ShaJin on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassesSelectViewDelegate.h"
@interface ClassesHeaderView : UIView

@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSString *allButtonTitle;
@property (nonatomic, weak) id<ClassesSelectViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame all:(BOOL)all;
- (void)removeSubViews;

@end
