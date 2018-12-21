//
//  ConfirmOrderViewController.h
//  XueWen
//
//  Created by ShaJin on 2018/3/1.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import "XWBaseViewController.h"

@interface ConfirmOrderViewController : XWBaseViewController

- (instancetype)initWithID:(NSString *)identifier type:(int)type updateBlcok:(void(^)(void))updateBlock;

@property (nonatomic,assign) BOOL isSuper;


@end
