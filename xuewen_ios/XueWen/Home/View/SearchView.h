//
//  SearchView.h
//  XueWen
//
//  Created by ShaJin on 2017/12/6.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchViewDelegate <NSObject>
- (void)selectAction;
@end

@interface SearchView : UIView
@property (nonatomic, weak) UIViewController *viewController;
@end
