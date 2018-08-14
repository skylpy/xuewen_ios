//
//  XWRankListController.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRankListController.h"
#import "XWRankViewController.h"

@interface XWRankListController ()

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation XWRankListController

#pragma mark - Getter
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [@[@"周榜", @"月榜", @"总榜"] mutableCopy];
    }
    return _titleArray;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.index == 0 ? @"学习排名" : @"目标排名";
}

- (instancetype)initWithIndex:(NSInteger)index{
    if (self = [super init]) {
        self.menuViewStyle = WMMenuViewStyleFlood;
        self.selectIndex = 0;
        self.pageAnimatable = YES;
        self.titleSizeSelected = 17;
        self.titleSizeNormal = 17;
        self.titleColorSelected = Color(@"#FFFFFF");
        self.titleColorNormal = Color(@"#666666");
        self.titleFontName = kMedFont;
        self.menuItemWidth = (kWidth-50)/3;
        self.progressColor = Color(@"#57A2FF");
        self.progressHeight = 30;
        self.index = index;
        [self reloadData];
    }
    return self;
}

#pragma mark - WMPageController Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        XWRankViewController *vc1 = [XWRankViewController new];
        vc1.type = ControllerTypeWeek;
        vc1.index = self.index;
        return vc1;
    }else if (index == 1){
        XWRankViewController *vc2 = [XWRankViewController new];
        vc2.type = ControllerTypeMonth;
        vc2.index = self.index;
        return vc2;
    }else{
        XWRankViewController *vc3 = [XWRankViewController new];
        vc3.type = ControllerTypeAll;
        vc3.index = self.index;
        return vc3;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    return self.titleArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    menuView.backgroundColor = Color(@"#DCECFF");
    [menuView rounded:16];
    return CGRectMake(25, 12, kWidth-50, 30);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0, 48, kWidth, kHeight);
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
