//
//  XWWebSocket.m
//  XueWen
//
//  Created by ShaJin on 2017/12/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "XWWebSocket.h"
#import <SocketRocket.h>
#import "AliyunVodPlayerSDK.h"

@interface XWWebSocket()<SRWebSocketDelegate>{
    int _index;
    NSTimer * heartBeat;
    NSTimeInterval reConnectTime;
}
@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong) NSMutableArray *dataQueue; // 发送的数据队列
@end
static XWWebSocket *webSocket = nil;
@implementation XWWebSocket
/** 登陆 */
- (void)login{
    if ([XWInstance shareInstance].accessToken){
        [self open];
    }
}

/** 注销 */
- (void)logout{
    [self close];
}

/** 开启链接 */
- (void)open{
    if (self.socket) {
        return;
    }
    
    self.socket.delegate = nil;
    [self.socket close];
    NSLog(@"登陆");
    //SRWebSocketUrlString 就是websocket的地址 写入自己后台的地址
    self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://120.78.221.202:8282"]]];
    self.socket.delegate = self;   //SRWebSocketDelegate 协议
    [self.socket open];     //开始连接
}

/** 关闭链接 */
- (void)close{
    if (self.socket){
        self.socket.delegate = nil;
        [self.socket close];
        self.socket = nil;
        
        //断开连接时销毁心跳
//        [self destoryHeartBeat];
    }
}

- (void)delayLogout{
    NSLog(@"下线");
    
    [[XWInstance shareInstance] logout];
    [self close];
}

#pragma mark - socket delegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    //收到服务器发过来的数据
    NSLog(@"message = %@",message);
    NSDictionary *dict = [NSDictionary dictionaryWithJsonString:message];
    if (dict) {
        if ([dict[@"code"] integerValue] == 43000 && [dict[@"message"] isEqualToString:@"账号在别处登录"]) {
            [Analytics event:EventLogout attributes:dict];
            if ([XWAudioInstanceController hasInstance]) {
                [[XWAudioInstanceController shareInstance].player stop];
            }
            XWWeakSelf
            [MBProgressHUD showWarnMessage:dict[@"message"] completionBlock:^{
                [weakSelf delayLogout];
            }];
            
            
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
    //开启心跳 心跳是发送pong的消息 我这里根据后台的要求发送data给后台
    XWUserInfo *userInfo = [XWInstance shareInstance].userInfo;
    NSLog(@"log id = %@",userInfo.oid);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"os_type":@"ios",@"ip":@"127.0.0.1",@"type":@"login",@"client_name":userInfo.nick_name,@"room_id":userInfo.company_id,@"user_id":userInfo.oid}];
//    NSLog(@"dict = %@",dict);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [self sendData:jsonData];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"连接失败，这里可以实现掉线自动重连");
//    NSLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
//    NSLog(@"2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量");
//    NSLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了，不然就死循环了。");
    _socket = nil;
    //连接失败就重连
    [self reConnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
  NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
  //断开连接 同时销毁心跳
  [self close];
}

/*
该函数是接收服务器发送的pong消息，其中最后一个是接受pong消息的，
在这里就要提一下心跳包，一般情况下建立长连接都会建立一个心跳包，
用于每隔一段时间通知一次服务端，客户端还是在线，这个心跳包其实就是一个ping消息，
我的理解就是建立一个定时器，每隔十秒或者十五秒向服务端发送一个ping消息，这个消息可是是空的
*/
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
  NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
  NSLog(@"reply===%@",reply);
}

#pragma mark - methods
//重连机制
- (void)reConnect{
    [self close];
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reConnectTime > 64) {
        NSLog(@"不再重连");
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.socket = nil;
        [self open];
        NSLog(@"重连");
    });
    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 2;
    }else{
        reConnectTime *= 2;
    }
}

- (void)sendData:(id)data {
    WeakSelf;
    dispatch_queue_t queue =  dispatch_queue_create("zy", NULL);
    dispatch_async(queue, ^{
      if (weakSelf.socket) {
          // 只有 SR_OPEN 开启状态才能调 send 方法，不然要崩
          if (weakSelf.socket.readyState == SR_OPEN) {
              [weakSelf.socket send:data];    // 发送数据
              
          } else if (weakSelf.socket.readyState == SR_CONNECTING) {
              NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
              // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
              // 只要有一次状态是 SR_OPEN 的就调用 [ws.socket send:data] 发送数据
              // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率的
              NSLog(@"断开重连3322");
              [self reConnect];
              
          } else if (weakSelf.socket.readyState == SR_CLOSING || weakSelf.socket.readyState == SR_CLOSED) {
              // websocket 断开了，调用 reConnect 方法重连
              NSLog(@"断开重连3320");
              [self reConnect];
          }
      } else {
          NSLog(@"没网络，发送失败，一旦断网 socket 会被我设置 nil 的");
      }
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark- onceToken  初始化
+ (instancetype) shareInstance{
    @synchronized (self) {
        if (webSocket == nil) {
            return [[self alloc] init];
        }
    }
    return webSocket;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webSocket = [super allocWithZone:zone];
    });
    return webSocket;
}

- (WebSocketState)state{
    WebSocketState state = 0;
    switch (self.socket.readyState) {
        case SR_CONNECTING:{
            state = kConnecting;
        }break;
        case SR_OPEN:{
            state = kOpen;
        }break;
        case SR_CLOSING:{
            state = kClosing;
        }break;
        case SR_CLOSED:{
            state = kClosed;
        }break;
        default:
            break;
    }
    return state;
}
@end
