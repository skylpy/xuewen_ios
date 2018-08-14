//
//  XWWebSocket.h
//  XueWen
//
//  Created by ShaJin on 2017/12/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger) {
    kConnecting     = 0,    // 连接中
    kOpen           = 1,    // 已经开启、可发送数据
    kClosing        = 2,    // 关闭中
    kClosed         = 3,    // 已关闭
}WebSocketState;
@interface XWWebSocket : NSObject
/** socket状态 */
@property(nonatomic,assign,readonly)WebSocketState state;

+ (instancetype) shareInstance;

/** 登陆 */
- (void)login;
/** 注销 */
- (void)logout;
@end
