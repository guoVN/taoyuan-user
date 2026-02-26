//
//  HMSocketManager.m
//  CherryTWanchor
//
//  Created by guo on 2026/2/26.
//

#import "HMSocketManager.h"
#import <SRWebSocket.h>

static NSString *kHeartString = @"ping";

@interface HMSocketManager ()<SRWebSocketDelegate>
{
    NSTimeInterval reConnecTime;
}

@property(nonatomic,strong)SRWebSocket *webSocket;
@property(nonatomic,strong)NSTimer *heartBeat;

@end

@implementation HMSocketManager

- (void)dealloc {
    [self removeNotification];
}

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static HMSocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance addNotification];
        [instance initSocket];
    });
    return instance;
}

- (void)initSocket
{
    if (_webSocket) {
        return;
    }
    
    // 未登陆不链接
//    if (![[YDUserManager sharedInstance] isLogin]) {
//        return;
//    }

    NSString *url = [NSString stringWithFormat:@"ws://test.hainanyihong.cn/chatserver/presence/user/%@?token=%@",[PGManager shareModel].userInfo.userid,[PGManager shareModel].userInfo.loginToken];
    NSLog(@"webSocket 链接到服务器：%@", url);
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url]];
    _webSocket.delegate = self;
    //  设置代理线程queue
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;
    [_webSocket setDelegateOperationQueue:queue];
    
    //  连接
    [_webSocket open];
}

//  初始化心跳
- (void)initHearBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        
        __weak typeof (self) weakSelf=self;
        //心跳设置为3分钟，NAT超时一般为5分钟
        weakSelf.heartBeat=[NSTimer scheduledTimerWithTimeInterval:15 repeats:YES block:^(NSTimer * _Nonnull timer) {
            
            //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
            [weakSelf sendMsg:kHeartString];
        }];
        [[NSRunLoop currentRunLoop] addTimer:weakSelf.heartBeat forMode:NSRunLoopCommonModes];
        
    });
}

//  取消心跳
- (void)destoryHeartBeat
{
    __weak typeof (self) weakSelf=self;
    dispatch_main_async_safe(^{
        if (weakSelf.heartBeat) {
            [weakSelf.heartBeat invalidate];
            weakSelf.heartBeat = nil;
        }
    });
}

//   建立连接
-(void)connect
{
    [self initSocket];
}

//   断开连接
-(void)disConnect
{
    if (_webSocket) {
        [_webSocket close];
        _webSocket = nil;
    }
}

//   发送消息
-(void)sendMsg:(NSString *)msg
{
    __weak typeof (self) weakSelf = self;
    dispatch_queue_t queue =  dispatch_queue_create("yy", NULL);
    dispatch_async(queue, ^{
        if (weakSelf.webSocket != nil) {
            // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
            if (weakSelf.webSocket.readyState == SR_OPEN) {
                NSError * error = nil;
                [weakSelf.webSocket sendString:msg error:&error]; // 发送数据
                
            } else if (weakSelf.webSocket.readyState == SR_CONNECTING) {
                NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
                // 每隔2秒检测一次 socket.readyState 状态，检测 10 次左右
                // 如果 10 次都还是没连上的，那这个发送请求就丢失了，这种情况是服务器的问题了，小概率
                [self reConnect];
                
            } else if (weakSelf.webSocket.readyState == SR_CLOSING || weakSelf.webSocket.readyState == SR_CLOSED) {
                // websocket 断开了，调用 reConnect 方法重连
                
                NSLog(@"重连");
                
                [self reConnect];
            }
        } else {
            NSLog(@"断开连接或者没网络，发送失败， socket 会被我设置 nil 的");
            
        }
    });
}

//  重连机制
-(void)reConnect
{
    [self disConnect];
    
    //  超过一分钟就不再重连   之后重连5次  2^5=64
    if (reConnecTime>64) {
        return;
    }
    __weak typeof (self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnecTime * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        weakSelf.webSocket=nil;
        [self initSocket];
    });
    
    //   重连时间2的指数级增长
    if (reConnecTime == 0) {
        reConnecTime =2;
    }else{
        reConnecTime *=2;
    }
}

// pingpong
- (void)ping{
    [_webSocket sendPing:nil error:nil];
}

#pragma mark - SRWebScokerDelegate
#pragma mark -
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{

    if ([message isEqualToString:kHeartString]) {
        return;
    }else{
        NSLog(@"webSocket 服务器返回的信息:%@",message);
        [self handleSocketMessage:message];
    }
    
}

// 链接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"webSocket 链接成功");
    [self initHearBeat];
    reConnecTime = 0;
}

//  open失败或者网络断开的时候调用
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"webSocket 链接断开:%@",error);
    //  失败了去重连
    [self reConnect];
}

//  手动断开
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    //被关闭连接，code:0,reason:(null),wasClean:1
    NSLog(@"webSocket 主动关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
    
    //断开连接
    [self disConnect];
        
    //断开连接时销毁心跳
    [self destoryHeartBeat];
}

//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}


#pragma mark - 通知处理
#pragma mark -
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutSuccess) name:@"loginOutSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logOutSuccess {
    [self disConnect];
}

- (void)logInSuccess {
    [self connect];
}

- (void)didBecomeActive {
//    if ([[YDUserManager sharedInstance] isLogin]) {
        [self connect];
//    } else {
//        [self disConnect];
//    }
}

- (void)didEnterBackground {
    [self disConnect];
}


#pragma mark - 长连接消息解析
#pragma mark -
- (void)handleSocketMessage:(id)message {
    if ([message isKindOfClass:[NSString class]]) {
        // json字符串
      
    }
}
@end
