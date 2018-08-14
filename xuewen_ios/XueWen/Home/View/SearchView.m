//
//  SearchView.m
//  XueWen
//
//  Created by ShaJin on 2017/12/6.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "SearchView.h"
#import "ClassesSearchViewController.h"
#import "MainNavigationViewController.h"
@interface SearchView()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@end
@implementation SearchView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.searchBar];
    }
    return self;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 7, kWidth - 30, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索课程";
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.backgroundColor = COLOR(238, 238, 238);
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor clearColor]];
            searchField.layer.cornerRadius = 0.0f;
            searchField.font = kFontSize(13);
        }
    }
    return _searchBar;
}

#pragma mark- UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (self.viewController) {
        MainNavigationViewController *navi = [[MainNavigationViewController alloc] initWithRootViewController:[ClassesSearchViewController new]];
        
        [self.viewController presentViewController:navi animated:NO completion:nil];
        return NO;
    }else{
        return YES;
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
