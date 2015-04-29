//
//  AppDelegate.m
//  xmpp
//
//  Created by admin on 15/4/28.
//  Copyright (c) 2015年 admin. All rights reserved.
//
#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "MRLoginTool.h"
#import "MRCommon.h"

@interface AppDelegate ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;//登录和注册结果block
    XMPPReconnect *_reconnect;//自动连接模块
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [self setupXmmpStream];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    //用户成功登录后，如果是重新启动程序，直接跳到主界面，否则跳到登录页面
    if([MRLoginTool loginStatu]){
        UIStoryboard *storybard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabVc = [storybard  instantiateInitialViewController];
        
        self.window.rootViewController = tabVc;
    }
    return YES;
}

#pragma mark 初始化xmppStream
-(void)setupXmmpStream{
    //1.创建对象
    _xmppStream = [[XMPPStream alloc] init];
    //添加自动连接模块
    //创建自动连接模块对象
    _reconnect = [[XMPPReconnect alloc] init];
    //激活
    [_reconnect activate:_xmppStream];
    //2.设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 连接到主机
-(void)connectToHost{
    NSLog(@"开始连接到主机");
    //设置用户jid
    //名字 + 域名
    //从沙盒获取登录信息
    NSString *user = [MRLoginTool user];
    NSString *domain =[MRLoginTool domain];
    //1.创建用户的jid
    XMPPJID *myJid = [XMPPJID jidWithUser:user domain:domain resource:nil];
    //2.设置xmppStream的登录用户jid
    _xmppStream.myJID = myJid;
    //3.设置服务器的端口
    _xmppStream.hostPort = 5222;
    //4.设置服务器地址
    _xmppStream.hostName = domain;
    //5.连接
    NSError *error = nil;
    BOOL success = [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (success == NO) {
        HMLogInfo(@"%@",error);
    }
    //发送通知到控制器(HMHistoryViewController)
    [self postNotification:XMPPResultTypeLogining];
}

#pragma mark 断开连接
-(void)disconnectFromHost{
    //1.通知用户下线
    //创建离线对象
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    //2.断开连接
    [_xmppStream disconnect];
}

#pragma mark -通知用户上线
-(void)goOnline{
     HMLogInfo(@"通知用户上线");
    //创建在线对象
    XMPPPresence *presence = [XMPPPresence presence];
    //发送在线消息到服务
    [_xmppStream sendElement:presence];
}

#pragma mark -xmpstream的代理
#pragma mark 连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
     HMLogInfo(@"连接成功");
    //连接成功之后，发送密码
    NSString *pwd = [MRLoginTool pwd];
    NSError *error = nil;
    
    if(self.isUserRegister){
        [_xmppStream registerWithPassword:pwd error:&error];
    }else{
       [_xmppStream authenticateWithPassword:pwd error:&error];
    }
    
    if (error) {
          HMLogInfo(@"%@",error);
    }
}

#pragma mark 连接失败
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
   HMLogInfo(@"%@",error);
    if (error) {
        //知识补充，在实际开发中为用户体验，不应该把下面信息提示给用户
        if (error.code == 8) {//域名不正确，不知道主机
            if (_resultBlock) {
                _resultBlock(XMPPResultTypeUnknowDomain);
            }
        }else if(error.code == 61){//服务器没有开启
            if (_resultBlock) {
                _resultBlock(XMPPResultTypeConnectionRefused);
            }
        }
        //连接失败 清除登录数据
        [self removeLoginInfo];
    }
}

#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
     HMLogInfo(@"授权成功");
    //授权成功之后，要通知用户上线
    [self goOnline];
//    if (_resultBlock) {
//        _resultBlock(XMPPResultTypeLoginSuccuess);
//    }
    //发送通知到控制器(HMHistoryViewController)
    [self postNotification:XMPPResultTypeLoginSuccuess];
    //切换storybard应该在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //授权成功之后应该跳到主界面
        UIStoryboard *storybard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //获取剪头所指的控制器
        UITabBarController *tabVc = [storybard  instantiateInitialViewController];
        UIViewController* old=self.window.rootViewController;
        if(![old isKindOfClass:[tabVc class]]){
           self.window.rootViewController = tabVc;
        }
    });
    //添加登录成功标识到沙盒
   [MRLoginTool setLoginStatu:YES];
}

#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
      HMLogInfo(@"授权失败 %@",error);
    //授权失败，把登录信息从沙盒里面移除
    [self removeLoginInfo];
    //发送通知到控制器(HMHistoryViewController)
    [self postNotification:XMPPResultTypeLoginFailure];
    //登录失败通过block通过登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    HMLogInfo(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    HMLogInfo(@"注册失败");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //如果用户登录过,应用程序退出到后台的时候，断开连接
    if([MRLoginTool loginStatu]){
        [self disconnectFromHost];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //如果用户登录过，自动连接到服务器
    if([MRLoginTool loginStatu]){
        //直接跳到主界面
        [self connectToHost];
    }
}

#pragma mark 消除沙盒用户登录数据
-(void)removeLoginInfo{
    [MRLoginTool removeLoginInfo];
}

#pragma mark 连接到服务器
-(void)xmppLogin:(XMPPResultBlock)resultBlock{
    HMLogInfo(@"连接到服务器");
    _resultBlock = resultBlock;
    //连接到服务器的时候，如果之前有存在连接，应该断
        if (_xmppStream.isConnected) {
            [_xmppStream disconnect];
        }

    [self connectToHost];
}


#pragma mark 用户注销
-(void)xmppLogout{
    //1.设置沙盒的登录状态标识为NO
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [MRLoginTool setLoginStatu:NO];
    [defaults synchronize];
    //2.从服务器断开连接
    [self disconnectFromHost];
    //3.切换回登录页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    self.window.rootViewController = storyboard.instantiateInitialViewController;
}

#pragma mark 用户注册
-(void)xmppRegister:(XMPPResultBlock)resultBlock{
    //把传进来的block赋值给_resultBlock
    _resultBlock = resultBlock;
    
    //连接到服务器的时候，如果之前有存在连接，应该断开
    [_xmppStream disconnect];
    
    [self connectToHost];
}
/**
 *  发送登录状态给HMHistoryViewControler
 *
 *  @param resultType 登录状态
 */
-(void)postNotification:(XMPPResultType)resultType{
    
    //要在主线程发送这个通知，控制器（HMHistoryViewControler）里的UI更新才没有问题
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = @{@"LoginStatu": @(resultType)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStatuNotification" object:nil userInfo:userInfo];
    });
    
}
-(void)dealloc{
    [self teardownStream];
}
-(void)teardownStream{
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //停止自动连接模块
    [_reconnect deactivate];
    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _xmppStream = nil;
    _reconnect = nil;
}
@end
