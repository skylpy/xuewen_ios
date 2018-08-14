//
//  XWGeneral.m
//  XueWen
//
//  Created by ShaJin on 2017/11/20.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWGeneral.h"
#import "NetworkViewController.h"
@interface XWGeneral()
@property(nonatomic,strong)NetworkViewController *netViewController;
@end
@implementation XWGeneral
- (void)setNetworkType:(AFNetworkReachabilityStatus)networkType{
    _networkType = networkType;
    if (networkType == AFNetworkReachabilityStatusNotReachable) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.netViewController animated:NO completion:nil];
    }else if (self.netViewController){
        [self.netViewController dismissViewControllerAnimated:NO completion:^{
            self.netViewController = nil;
        }];
        
    }
}

- (NetworkViewController *)netViewController{
    if (!_netViewController) {
        NetworkViewController *viewController = [[NetworkViewController alloc] initWithNoNetwork:YES];
        _netViewController = viewController;
    }
    return _netViewController;
}




@end
