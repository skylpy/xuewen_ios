//
//  MineEditViewController.h
//  XueWen
//
//  Created by ShaJin on 2017/11/17.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWBaseViewController.h"
typedef enum : NSUInteger {
    kEditName,      // 编辑姓名
    kEditNickName,  // 编辑昵称
    kEditSignature, // 编辑个人签名
} EditViewType;
@interface MineEditViewController : XWBaseViewController

- (instancetype)initWithText:(NSString *)text viewType:(EditViewType)type complete:(void(^)(NSString *text))complete;

@end
