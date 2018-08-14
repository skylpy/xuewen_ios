//
//  UISearchBar+Extension.m
//  XueWen
//
//  Created by ShaJin on 2017/12/18.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "UISearchBar+Extension.h"

@implementation UISearchBar (Extension)
- (void)setCancelButtonTitle:(NSString *)title {
    if (IsLaterVersion(9)) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
    }
}
@end
