//
//  XWListViewController.m
//  XueWen
//
//  Created by ShaJin on 2017/12/26.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWListViewController.h"
#import "MJRefresh.h"
@interface XWListViewController ()<UIScrollViewDelegate>
//@property(nonatomic,strong)
{
    UIView *_defaultPage;
}
@end

@implementation XWListViewController
#pragma mark- ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 判断滑动方向
    static float newy = 0;
    static float oldy = 0;
    newy = scrollView.contentOffset.y;
    if (newy != oldy) {
        if (newy > oldy) {
            // appear
        }else{
            // disappear
        }
    }
    oldy = newy;
    self.isDraging = YES;
}

#pragma mark- CustomMethod
- (void)initUI{
    
}

- (void)loadData{
    
}

- (void)loadedDataWithArray:(NSArray *)array isLast:(BOOL)isLast{
    [self.array addObjectsFromArray:array];
    if ([self.scrollView respondsToSelector:@selector(reloadData)]) {
        [self.scrollView performSelector:@selector(reloadData)];
    }
    [self.scrollView.mj_header endRefreshing];
    if (isLast) {
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.scrollView.mj_footer endRefreshing];
    }
    self.showDefaultPage = (array.count == 0);
    self.scrollView.mj_footer.hidden = (self.array.count < 3) ; // 2018.01.31 当数据条数小于3条时不显示footer
}

- (void)addHeaderWithAction:(SEL)action{
    WeakSelf;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:action];
    self.scrollView.mj_header.refreshingBlock = ^{
        weakSelf.page = 1;
        [weakSelf.array removeAllObjects];
        if ([weakSelf.scrollView respondsToSelector:@selector(reloadData)]) {
            [weakSelf.scrollView performSelector:@selector(reloadData)];
        }
        weakSelf.scrollView.mj_footer.hidden = YES;
        weakSelf.defaultPage.hidden = YES;
    };
}

- (void)addFooterWithAction:(SEL)action{
    self.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:action];
    self.scrollView.mj_footer.hidden = YES;
}

- (void)addHeaderFooterAction:(SEL)action{
    [self addHeaderWithAction:action];
    [self addFooterWithAction:action];
}

- (void)beginLoadData{
    self.defaultPage.hidden = YES;
    [self.scrollView.mj_header beginRefreshing];
}

/** 结束加载 */
- (void)endedLoadData{
    [self.scrollView.mj_header endRefreshing];
    [self.scrollView.mj_footer endRefreshing];
    if ([self.scrollView respondsToSelector:@selector(reloadData)]) {
        [self.scrollView performSelector:@selector(reloadData)];
    }
}

#pragma mark- Setter
- (void)setScrollView:(UIScrollView *)scrollView{
    if (_scrollView) {
        [_defaultPage removeFromSuperview];
        [_scrollView removeFromSuperview];
    }
    _scrollView = scrollView;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:self.defaultPage];
}

- (void)setShowDefaultPage:(BOOL)showDefaultPage{
    _showDefaultPage = showDefaultPage;
    self.scrollView.mj_footer.hidden = showDefaultPage;
    if (showDefaultPage) {
        [self.scrollView addSubview:self.defaultPage];
    }else{
        [self.defaultPage removeFromSuperview];
    }
    self.defaultPage.hidden = !showDefaultPage;
}

#pragma mark- Getter
- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (UIView *)defaultPage{
    if (!_defaultPage) {
        _defaultPage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        _defaultPage.backgroundColor = self.view.backgroundColor;;
        UIImageView *imageView = [UIImageView new];
        imageView.image = LoadImage(@"iconRecordEmpty");
        [_defaultPage addSubview:imageView];
        UILabel *label = [UILabel labelWithTextColor:DefaultTitleCColor size:14];
        label.text = @"暂无相关记录";
        [_defaultPage addSubview:label];
        
        imageView.sd_layout.centerXEqualToView(_defaultPage).topSpaceToView(_defaultPage,30).widthIs(70).heightIs(70);
        label.sd_layout.centerXEqualToView(_defaultPage).topSpaceToView(imageView,8.5).heightIs(14).widthIs([label.text widthWithSize:14]);
        
        _defaultPage.hidden = YES;
    }
    return _defaultPage;
}
#pragma mark- LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.scrollView) {
        self.scrollView.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
