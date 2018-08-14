//
//  XWListViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/12/26.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWBaseViewController.h"

@interface XWListViewController : XWBaseViewController
/** TableView 或 CollectionView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *array;
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 是否显示缺省页 */
@property (nonatomic, assign) BOOL showDefaultPage;
/** 缺省页 */
@property (nonatomic, strong) UIView *defaultPage;

/** 刷新数据相关 */
- (void)loadedDataWithArray:(NSArray *)array isLast:(BOOL)isLast;
/** 执行此方法之前要先设置ScrollView */
- (void)addHeaderWithAction:(SEL)action;
/** 执行此方法之前要先设置ScrollView */
- (void)addFooterWithAction:(SEL)action;
/** 同时设置以上两个 */
- (void)addHeaderFooterAction:(SEL)action;
/** 加载数据 */
- (void)beginLoadData;
/** 结束加载 */
- (void)endedLoadData;
@end
