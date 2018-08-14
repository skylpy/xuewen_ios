//
//  XWCatalogView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCoursModel.h"

@protocol XWCatalogViewDelegate <NSObject>

/** 点击了目录按钮*/
- (void)catalogBtnClick:(UIButton *)sender;

@end

@interface XWCatalogView : UIView

@property (nonatomic, strong) XWCoursModel *model;

@property (nonatomic, assign) id<XWCatalogViewDelegate> delegate;

@end
