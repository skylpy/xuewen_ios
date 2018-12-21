//
//  HomeViewController.m
//  XueWen
//
//  Created by Pingzi on 2017/11/13.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "HomeTabController.h"
#import "MainNavigationViewController.h"
#import "ClassesViewController.h"
#import "MineViewController.h"
#import "MyCoursesViewController.h"
#import "XWHomeController.h"
#import "XWMyCoursesViewController.h"
#import "XWFindViewController.h"

@interface HomeTabController () <UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray *viewControllers;  // 子控制器个数；
@property (nonatomic, strong) NSDate *lastDate;
@end

@implementation HomeTabController
@synthesize viewControllers;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*** 子控制器数组初始化 ***/
    self.viewControllers = [NSMutableArray arrayWithCapacity:4];
    
    /*** 设置子控制器 ***/
    [self setupControllers];
    
    /*** 设置tabBar ***/
    [self setupTabBar];
    
    [self setupItemTitleTextAttributes];
    
    /*** 添加子控件 ***/
    [self addChildController];
    self.delegate = self;
}

/**
 *  设置子控制器
 */
- (void)setupControllers
{
    MainNavigationViewController *navOne = [[MainNavigationViewController alloc] initWithRootViewController:[XWHomeController homePageVC]];
    MainNavigationViewController *navTwo = [[MainNavigationViewController alloc] initWithRootViewController:[[XWFindViewController alloc] init]];
    MainNavigationViewController *navThree = [[MainNavigationViewController alloc] initWithRootViewController:[XWMyCoursesViewController new]];
    MainNavigationViewController *navFour = [[MainNavigationViewController alloc] initWithRootViewController:[[MineViewController alloc] init]];
    
    
    [self.viewControllers addObjectsFromArray:@[navOne,navTwo,navThree,navFour]];
}

/**
 *  设置所有UITabBarItem的文字属性
 */
- (void)setupItemTitleTextAttributes
{
    // 普通状态下的文字属性
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color(@"#bcbcbc"), NSForegroundColorAttributeName,[UIFont fontWithName:kRegFont size:9],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // 选中状态下的文字属性
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Color(@"#333333"), NSForegroundColorAttributeName, [UIFont fontWithName:kRegFont size:9],NSFontAttributeName, nil] forState:UIControlStateSelected];
    
}

/**
 *  设置所有UITabBar
 */
- (void)setupTabBar
{
    
    //tabbar backgroundColor
//    [[UITabBar appearance] setBarTintColor:ColorA(204, 208, 225, 0.2)];
    //tabbar的分割线的颜色
    //    [UITabBar appearance] set;
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setTranslucent:NO];
    [self dropShadowWithOffset:CGSizeMake(0, -2.5)
                        radius:6
                         color:COLOR(204, 204, 204)
                       opacity:0.2];
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}

/**
 *  添加子控件
 */
- (void)addChildController
{
    NSArray *arr =
  @[
    @{@"title":@"首页",@"normalImageName":@"ico_home_normal",@"selectImageName":@"ico_home_selected"},
    @{@"title":@"发现",@"normalImageName":@"icon_find_normal",@"selectImageName":@"icon_find_selected"},
    @{@"title":@"我的学习",@"normalImageName":@"ico_my_study_normal",@"selectImageName":@"ico_my_study_selected"},
    @{@"title":@"我的",@"normalImageName":@"ico_my_normal",@"selectImageName":@"ico_my_selected"}
  ];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        UIViewController *vc = self.viewControllers[idx];
        NSString *title = [dic objectForKey:@"title"];
        NSString *normalImageName = [dic objectForKey:@"normalImageName"];
        NSString *selectImageName = [dic objectForKey:@"selectImageName"];
        
        // 添加子控件，初始化items
        [self addController:vc title:title normolImageName:normalImageName selectImageName:selectImageName];
    }];
}

/**
 *  添加子控制器，初始化tabbarItem
 */
- (void)addController:(UIViewController *)viewController title:(NSString *)title normolImageName:(NSString *)normalImageName selectImageName:(NSString *)selectImageName
{
    viewController.tabBarItem.title = title;
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = normalImage;
    
    UIImage *selectedImage = [UIImage imageNamed:selectImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    // tabbar文字上移
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    
    [self addChildViewController:viewController];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[XWHomeController class]]) {
        [Analytics event:EventTabbarHome];
    }else if ([viewController isKindOfClass:[XWMyCoursesViewController class]]){
        [Analytics event:EventTabbarStudy];
    }else{
        [Analytics event:EventTabbarMine];
    }
    if ([self doubleClick]) {
        UINavigationController *navigation =(UINavigationController *)viewController;
        if ([navigation.topViewController respondsToSelector:@selector(tabbarDoubleClick)]) {
            [navigation.topViewController performSelector:@selector(tabbarDoubleClick)];
        }
        
    }
}

/*判断是否是双击(因为系统并没有提供双击的方法, 可以通过点击的时间间隔来判断)*/
- (BOOL)doubleClick {
    NSDate *date = [NSDate date];
    
    if (date.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.5) {
        //完成一次双击后，重置第一次单击的时间，区分3次或多次的单击
        self.lastDate = [NSDate dateWithTimeIntervalSince1970:0];
        
        return YES;
    }
    
    self.lastDate = date;
    return NO;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
