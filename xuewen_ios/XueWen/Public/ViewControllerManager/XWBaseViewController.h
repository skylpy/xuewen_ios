//
//  XWBaseViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/12/26.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWBaseViewController : UIViewController
/** 加载视图 这个方法是自动调用的，子类里只需重写就可以 */
- (void)initUI;
/** 请求数据 这个方法是自动调用的，子类里只需重写就可以 */
- (void)loadData;
/** 隐藏导航栏底部细线 */
- (BOOL)hiddenNaviLine;
/** 隐藏导航栏 */
- (BOOL)hiddenNavigationBar;
/** 设置右侧按钮（文字形式）这两个方法只能用其中一个，一个以上按钮时须要用传统方法添加 */
- (UIButton *)setRightItemWithTitle:(NSString *)title action:(SEL)action;
/** 设置右侧按钮（图片形式）这两个方法只能用其中一个，一个以上按钮时须要用传统方法添加 */
- (UIButton *)setRightItemWithImage:(UIImage *)image action:(SEL)action;
/** POP回到指定的界面 */
- (void)popToViewController:(NSString *)className;
/** AudioPlayerView的height */
- (CGFloat)audioPlayerViewHieght;
/** ScorllView将要滑动 */
- (void)scrolling:(UIScrollView *)scrollView;

@property (nonatomic, assign) BOOL isDraging;

@end
