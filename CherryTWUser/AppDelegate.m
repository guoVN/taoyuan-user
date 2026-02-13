//
//  AppDelegate.m
//  CherryTWUser
//
//  Created by guo on 2024/4/7.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PGTabbarViewController.h"
#import "PGNavigationViewController.h"
#import "PGCustomViewController.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <UserNotifications/UserNotifications.h>
#import "PGLoginModel.h"
#import "PGMessageListModel.h"
#import "PGAudioSessionObject.h"
#import "PGVideoCallViewController.h"
#import "PGVideoInitiationViewController.h"
#import <Bugly/Bugly.h>
#import "PGContainerVC.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,AgoraChatManagerDelegate,AgoraChatClientDelegate>

///是否正式环境
@property (nonatomic, assign) BOOL isPreEv;
@property (nonatomic, strong) NSArray * addressArr;
@property (nonatomic, strong) UNUserNotificationCenter *center;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgrounTask;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) NSTimer * heartTimer;
@property (nonatomic, assign) NSInteger requestDomainCount;
@property (nonatomic, strong) UIApplication * appCation;
@property (strong, nonatomic) AVAudioPlayer * audioPlayer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#if DEBUG
    self.isPreEv = NO;
#else
    self.isPreEv = YES;
#endif
    self.appCation = application;
    self.requestDomainCount = 0;
    [Bugly startWithAppId:@"4637b2c21f"];
    [self getDomain];
    [PGUtils getUserAgent];
    [self setLanguage];
    [self setupKeyboardManager];
    [self netSet];
    [self createTimer];
    [self initializeLocalNotification];
    [self setupAgoraChat];
    [self applicationPushRegister:application];
    [self initPushData:launchOptions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterAction) name:@"FirstEnterState" object:nil];
    return YES;
}
- (void)toMain
{
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(heartAction) userInfo:nil repeats:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"];
    if (isLogin) {
//        PGTabbarViewController * tabbar = [[PGTabbarViewController alloc] init];
//        self.window.rootViewController = tabbar;
        PGContainerVC * vc = [[PGContainerVC alloc] init];
        PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
        [self reRequestData];
    }else{
        PGCustomViewController * vc = [[PGCustomViewController alloc] init];
        PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    [self.window makeKeyAndVisible];
}
- (void)setLanguage
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:@"appLanguage"];
        }
    }
}
/// 全局键盘管理
- (void)setupKeyboardManager{
    
    [IQKeyboardManager sharedManager].enable = YES; // 控制整个功能是否启用
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; //隐藏键盘上方工具条
    IQKeyboardManager.sharedManager.toolbarDoneBarButtonItemText = @"完成";

}
- (void)netSet
{
    ///无声播放
    [[PGAudioSessionObject shareManager] creatAVAudioSessionObject];
    [[HMNetworking sharedClient] get:@"https://m.baidu.com" parameters:@{} headers:nil success:^(id  _Nullable responseObject) {
            
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(applyToSystemForMoreTime) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)loadService
{
    [PGAPIService getUserDefaultHeadImgWithParameters:@{@"code":@"customServiceLink",@"channel":Channel_Name} Success:^(id  _Nonnull data) {
        [PGManager shareModel].searviceLinkStr = data[@"data"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)loadChatCoin
{
    [PGAPIService getUserDefaultHeadImgWithParameters:@{@"code":@"chatUnlockCoin",@"channel":Channel_Name} Success:^(id  _Nonnull data) {
        [PGManager shareModel].chatUnlockCoin = data[@"data"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)loadChannelNo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:[PGUtils getAdId] forKey:@"androidid"];
    [dic setValue:[PGUtils getAdId] forKey:@"imei"];
    [dic setValue:[PGUtils getAdId] forKey:@"oaid"];
    [dic setValue:@"" forKey:@"ipv6"];
    [dic setValue:Package_Name forKey:@"packName"];
    [dic setValue:Channel_Name forKey:@"channel"];
    [dic setValue:[PGManager shareModel].userAgent forKey:@"ua"];
    [dic setValue:[PGUtils getMacAddress] forKey:@"mac"];
    [PGAPIService checkChannelNoWithParameters:dic Success:^(id  _Nonnull data) {
        NSDictionary * dic = data[@"data"];
        [PGManager shareModel].channelNo = dic[@"channelNo"];
        [PGManager shareModel].promptionChannel = dic[@"promotionChannel"];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}
- (void)loadGiftData
{
    [PGAPIService diamondListWithParameters:@{@"packName":@"ntdlaz"} Success:^(id  _Nonnull data) {
        PGRechargeListModel * rechargeModel = [PGRechargeListModel mj_objectWithKeyValues:data[@"data"]];
        [PGManager shareModel].giftArray = [rechargeModel.otherSetting.presentCoins mutableCopy];
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

- (void)setupAgoraChat
{
    [PGManager shareModel].userInfo = [PGLoginModel readInfo];
    AgoraChatOptions *options = [AgoraChatOptions optionsWithAppId:AgroaAppid];
    // apnsCertName是证书名称，可以先传 nil，等后期配置 APNs 推送时在传入证书名称
    options.apnsCertName = AgroaIMcertificate;
    options.isAutoLogin = YES;
    [[AgoraChatClient sharedClient] initializeSDKWithOptions:options];
    [[AgoraChatClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[AgoraChatClient sharedClient] addDelegate:self delegateQueue:nil];
}
- (void)initPushData:(NSDictionary *)launchOptions{
    ///推送自定义消息
//    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
}
///注册推送
- (void)applicationPushRegister:(UIApplication *)application
{
    // 注册推送。
    if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSLog(@"推送权限已授权");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [application registerForRemoteNotifications]; // 必须在主线程执行
                    });
                }
            }];
        } else {
            // iOS 9及以下
//            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge) categories:nil];
//            [application registerUserNotificationSettings:settings];
//            [application registerForRemoteNotifications];
        }
  AgoraChatOptions *options = [AgoraChatOptions optionsWithAppId:AgroaAppid];
  // 填写上传证书时设置的名称。
  options.apnsCertName = AgroaIMcertificate;
  [AgoraChatClient.sharedClient initializeSDKWithOptions:options];
}

// iOS 10及以上：前台接收推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    // 解析声网IM推送内容（格式见下文）
    [self handleAgoraPushNotification:userInfo isForeground:YES];
    // 前台显示推送（按需配置）
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

// 点击推送通知打开应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self handleAgoraPushNotification:userInfo isForeground:NO];
    completionHandler();
}

// 处理声网IM推送内容
- (void)handleAgoraPushNotification:(NSDictionary *)userInfo isForeground:(BOOL)isForeground {
    // 声网推送格式示例：{"from":"用户ID","msg":"消息内容","type":"txt","convType":"singleChat","convId":"会话ID"}
    NSString *convId = userInfo[@"convId"]; // 会话ID
    NSString *msgContent = userInfo[@"msg"]; // 消息内容
    NSString *fromUserId = userInfo[@"from"]; // 发送者ID
    NSLog(@"%@==%@",convId,fromUserId);
    if (!isForeground) {
        // 后台点击：跳转到对应会话页面
   
    } else {
        // 前台接收：更新UI或显示本地通知
        NSLog(@"收到新消息：%@", msgContent);
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 异步方法
    [AgoraChatClient.sharedClient registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(AgoraChatError *aError) {
        if (aError) {
            NSLog(@"bind deviceToken error: %@", aError.errorDescription);
        }
    }];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Register Remote Notifications Failed");
}

#pragma mark===AgoraChatManagerDelegate
- (void)messagesDidReceive:(NSArray *)aMessages
{
    // 收到消息，遍历消息列表。
    for (AgoraChatMessage *message in aMessages) {
    // 消息解析和展示。
        AgoraChatTextMessageBody *textBody = (AgoraChatTextMessageBody *)message.body;
        NSLog(@"%@",textBody.text);
        NSDictionary * msgDic = [PGUtils jsonToObject:textBody.text];
        NSString * msgType = msgDic[@"type"];
        if ([msgType isKindOfClass:[NSNull class]]) {
            msgDic = [PGUtils jsonToObject:msgDic[@"content"]];
        }
        RLMResults *results = [PGMessageListModel allObjects];
        RLMRealm *realm = [RLMRealm defaultRealm];
        PGMessageListModel * messageModel = [[PGMessageListModel alloc] init];
        messageModel.messageId = message.conversationId;
        messageModel.avatar = msgDic[@"senderPhoto"];
        messageModel.nickName = msgDic[@"senderName"];
        messageModel.extendStr1 = msgDic[@"senderid"];
        
        NSString * type = msgDic[@"type"];
        NSString * contentStr = msgDic[@"content"];
        if ([contentStr containsString:@"!@#!@#"]) {///视频聊天发消息时用
            [[NSNotificationCenter defaultCenter] postNotificationName:@"videoChat" object:nil userInfo:@{@"content":message}];
        }
        
        if ([type isEqualToString:@"文字"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgContent" object:nil userInfo:@{@"msg":message}];
        }else if([type isEqualToString:@"礼物"]){
            for (PGGiftListModel * giftModel in [PGManager shareModel].giftArray) {
                if ([giftModel.name isEqualToString:contentStr]) {
                    PGNavigationViewController * nav = (PGNavigationViewController *)self.window.rootViewController;
                    PGContainerVC * tabbarVC = (PGContainerVC *)nav.topViewController;
                    [tabbarVC showSvga:giftModel.dynamicPic];
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgContent" object:nil userInfo:@{@"msg":message}];
        }else if ([type isEqualToString:@"视频"]) {
            if ([[PGUtils getCurrentVC] isMemberOfClass:[PGVideoInitiationViewController class]] || [[PGUtils getCurrentVC] isMemberOfClass:[PGVideoCallViewController class]]) {
                return;
            }
            [PGManager shareModel].currentCallMsgId = message.messageId;
            [PGManager shareModel].currentCallConversationId = message.conversationId;
            PGVideoCallViewController * vc = [[PGVideoCallViewController alloc] init];
            vc.channelId = msgDic[@"senderid"];
            vc.callType = 3;
            vc.anchorName = msgDic[@"senderName"];
            vc.anchorHeadStr = msgDic[@"senderPhoto"];
            vc.callDuration = contentStr;
            PGNavigationViewController * nav = [[PGNavigationViewController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [[PGUtils getCurrentVC] presentViewController:nav animated:YES completion:nil];
            AgoraChatConversation *conversation = [AgoraChatClient.sharedClient.chatManager getConversationWithConvId:msgDic[@"senderid"]];
            AgoraChatError *error;
            [conversation deleteMessageWithId:[PGManager shareModel].currentCallMsgId error:&error];
        }else if ([type isEqualToString:@"取消"] || [type isEqualToString:@"拒绝"] || [type isEqualToString:@"挂断"]) {
            AgoraChatConversation *conversation = [AgoraChatClient.sharedClient.chatManager getConversationWithConvId:msgDic[@"senderid"]];
            AgoraChatError *error;
            [conversation deleteMessageWithId:[PGManager shareModel].currentCallMsgId error:&error];
            if ([PGManager shareModel].currentCallConversationId.length>0 && ![[PGManager shareModel].currentCallConversationId isEqualToString:message.conversationId]) {
                return;
            }
            if ([type isEqualToString:@"挂断"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMsgCallTime" object:nil userInfo:@{@"msg":message,@"data":msgDic}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMsgContent" object:nil userInfo:@{@"msg":message}];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"otherCloseCall" object:nil userInfo:nil];
                });
            }
        }else{
            AgoraChatConversation *conversation = [AgoraChatClient.sharedClient.chatManager getConversationWithConvId:msgDic[@"senderid"]];
            AgoraChatError *error;
            [conversation deleteMessageWithId:message.messageId error:&error];
        }
        
        if ([type isEqualToString:@"文字"] || [type isEqualToString:@"礼物"]) {
            if (![messageModel.messageId isEqualToString:[PGManager shareModel].userInfo.userid]) {
                [self creatAVAudioSessionObject];
                [self vibrate];
            }
        }
        
        BOOL isSameID = NO;
        __block PGMessageListModel * sameModel;
        for (PGMessageListModel * listModel in results) {
            if ([listModel.messageId integerValue] == [messageModel.messageId integerValue]) {
                isSameID = YES;
                sameModel = listModel;
            }
        }
        [realm transactionWithBlock:^{
            if (!isSameID) {
                [realm addObject:messageModel];
            }else{
                sameModel.avatar = messageModel.avatar;
                sameModel.nickName = messageModel.nickName;
            }
        }];
        
        if ([type isEqualToString:@"文字"] || [type isEqualToString:@"视频"] || [type isEqualToString:@"礼物"]) {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = messageModel.nickName;
            if ([type isEqualToString:@"视频"]){
                content.body = @"[视频通话]";
            }else{
                if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"图片"]) {
                    content.body = @"[图片]";
                }else if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"视频"]){
                    content.body = @"[视频]";
                }else if ([[PGUtils getFileFormat:contentStr] isEqualToString:@"语音"]){
                    content.body = @"[语音]";
                }else{
//                    NSArray * arr = [contentStr componentsSeparatedByString:@"!!@@##"];
//                    content.body = arr.firstObject;
                    content.body = contentStr;
                }
            }
            
            content.sound = [UNNotificationSound defaultSound];
            //创建触发器
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            //创建通知请求
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[PGUtils getCurrentTimeStamp] content:content trigger:trigger];
            //添加通知请求到通知中心
            [self.center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                // 处理添加通知请求的结果
                dispatch_async(dispatch_get_main_queue(),^{

                });
                
            }];
        }
        
    }
    [self unReadMsgCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWMSG" object:nil userInfo:nil];
}
- (void)unReadMsgCount
{
    PGNavigationViewController * nav = (PGNavigationViewController *)self.window.rootViewController;
    PGContainerVC * tabbarVC = (PGContainerVC *)nav.topViewController;
    NSArray <AgoraChatConversation *>*conversations = [AgoraChatClient.sharedClient.chatManager getAllConversations:YES];
    NSInteger unreadCount = 0;
    for (AgoraChatConversation *conversation in conversations) {
        if (![conversation.conversationId isEqualToString:@"99999999"]) {
            unreadCount += conversation.unreadMessagesCount;
        }
    }
    
    if ([tabbarVC isMemberOfClass:[PGContainerVC class]]) {
        [tabbarVC.floatingTabBar setBadgeValue:[NSString stringWithFormat:@"%ld",unreadCount] forIndex:2];
        if (unreadCount == 0) {
            [tabbarVC.floatingTabBar setBadgeValue:nil forIndex:2];
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount;
}
/// 创建音乐播放器
- (void)creatAVAudioSessionObject{
    //设置后台模式和锁屏模式下依然能够播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    //初始化音频播放器
    NSError *playerError;
    NSURL *urlSound = [[NSURL alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"sp" ofType:@"wav"]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSound error:&playerError];
    self.audioPlayer.volume = 1;
    [PGManager shareModel].audioPlayer = self.audioPlayer;
}
- (void)vibrate
{
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //音频
    [[PGManager shareModel].audioPlayer play];
}

- (void)applicationEnterAction
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self updateState:@"在线"];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FirstEnterState" object:nil];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"];
    if (isLogin && [PGManager shareModel].isUpdateUserInfo) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateState:@"在线"];
        });
    }
    [[PGAudioSessionObject shareManager] stopPlayAudioSession];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    if (@available(ios 14.5,*)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    NSLog(@"status = %lu",(unsigned long)status);
                    if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                        // 后续操作
                    }
                }];
    }
}

//应用程序已经进入后台运行
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[PGAudioSessionObject shareManager] startPlayAudioSession];    //创建一个背景任务去和系统请求后台运行的时间
    [self.timer setFireDate:[NSDate date]];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"];
    if (isLogin) {
        [self updateState:@"离线"];
    }
}

#pragma mark===修改在线状态
- (void)updateState:(NSString *)state
{
    [PGAPIService updateUserStateWithParameters:@{@"state":state} Success:^(id  _Nonnull data) {
            
    } failure:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

#pragma mark===心跳接口
- (void)heartAction
{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"];
    if (!isLogin) {
        return;
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:[PGManager shareModel].userInfo.userid forKey:@"userid"];
        [PGAPIService heartWithParameters:dic Success:^(id  _Nonnull data) {
                    
        } failure:^(NSInteger code, NSString * _Nonnull message) {
            if (code == 406) {
                [QMUITips showWithText:@"当前用户被封禁"];
                [PGUtils loginOut];
            }
        }];
    }
}

- (void)initializeLocalNotification {
    self.center = [UNUserNotificationCenter currentNotificationCenter];
    self.center.delegate = self;
    [self.center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionBadge + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        // 处理授权结果
        
    }];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付时，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

        }];
        return YES;
    }
    return YES;
}

#pragma mark - 定时器设置判断后台保活时间，如果将要被后台杀死，重新唤醒
- (void)applyToSystemForMoreTime {
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 30.0) {//如果剩余时间小于30秒
        [[UIApplication sharedApplication] endBackgroundTask:self.self.backgrounTask];
        self.backgrounTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.self.backgrounTask];
            self.backgrounTask = UIBackgroundTaskInvalid;
        }];
    }
}

- (void)getDomain
{
    if (self.isPreEv) {
        self.addressArr = @[@"https://a.vom2x5nf.com/test",@"https://a.31k4owma.com/test",@"https://a.bt9o7q51.com/test"];
        self.addressArr = [PGUtils getRadomArr:self.addressArr];
        NSString * reqUrl = self.addressArr.firstObject;
        [self doPreDomainRequest:reqUrl withArr:self.addressArr];
    }else{
        // mt.huayuan123.com
        [PGManager shareModel].baseUrl = @"https://test.hainanyihong.cn/chatserver/";
        [self toMain];
    }
}
- (void)doPreDomainRequest:(NSString *)reqUrl withArr:(NSArray*)addressArr
{
    WeakSelf(self)
    [[HMNetworking sharedClient] get:reqUrl parameters:@{} headers:nil success:^(id  _Nullable responseObject) {
        NSString * domain = responseObject[@"b"];
        if (![domain hasPrefix:@"http"]) {
            domain = [NSString stringWithFormat:@"http://%@",domain];
        }
        domain = [domain stringByAppendingString:@"/chatserver/"];
        [PGManager shareModel].baseUrl = domain;
        [weakself toMain];
    } failure:^(NSError *error) {
        weakself.requestDomainCount++;
        if (weakself.requestDomainCount == weakself.addressArr.count) {
            [QMUITips showWithText:@"网络无法访问"];
        }else{
            NSString * url = addressArr[weakself.requestDomainCount];
            [weakself doPreDomainRequest:url withArr:weakself.addressArr];
        }
 
    }];
}
///登录成功后重载资源
- (void)reRequestData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL imLogin = AgoraChatClient.sharedClient.isLoggedIn;
        if (!imLogin) {
            [PGUtils loginIM:[PGManager shareModel].userInfo];
        }
        [self applicationPushRegister:self.appCation];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadService];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadChatCoin];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadChannelNo];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadGiftData];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self unReadMsgCount];
    });
}

@end
