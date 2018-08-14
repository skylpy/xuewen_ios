//
//  XWHotCoursListController.m
//  XueWen
//
//  Created by Karron Su on 2018/7/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWHotCoursListController.h"
#import "XWHotCoursViewController.h"

@interface XWHotCoursListController ()

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation XWHotCoursListController

#pragma mark - Getter
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [@[@"周", @"月", @"总"] mutableCopy];
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门课程";
}

- (instancetype)init{
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
    }
    return self;
}

#pragma mark - WMPageController Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.titleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        XWHotCoursViewController *vc1 = [XWHotCoursViewController new];
        vc1.type = ControllerTypeWeek;
        return vc1;
    }else if (index == 1){
        XWHotCoursViewController *vc2 = [XWHotCoursViewController new];
        vc2.type = ControllerTypeMonth;
        return vc2;
    }else{
        XWHotCoursViewController *vc3 = [XWHotCoursViewController new];
        vc3.type = ControllerTypeAll;
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
    return CGRectMake(0, 42, kWidth, kHeight);
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
