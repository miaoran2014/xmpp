//
//  AppDelegate.m
//  xmpp
//
//  Created by admin on 15/4/28.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

@interface AppDelegate ()<XMPPStreamDelegate>{
     XMPPStream *_xmppStream;
}

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [self setupXmmpStream];
    return YES;
}

#pragma mark 初始化xmppStream
-(void)setupXmmpStream{
    //1.创建对象
    _xmppStream = [[XMPPStream alloc] init];
    
    //2.设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 连接到主机
-(void)connectToHost{
    NSLog(@"开始连接到主机");
    
    //设置用户jid
    //名字 + 域名
    NSString *user = @"ran";
    NSString *domain = @"localhost";
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
        NSLog(@"%@",error);
    }
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
    NSLog(@"通知用户上线");
    //创建在线对象
    XMPPPresence *presence = [XMPPPresence presence];
    //发送在线消息到服务
    [_xmppStream sendElement:presence];
}

#pragma mark -xmpstream的代理
#pragma mark 连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"连接成功");
    
    //连接成功之后，发送密码
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:@"111108" error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}

#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"授权成功");
    //授权成功之后，要通知用户上线
    [self goOnline];
    
}

#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 %@",error);
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //用户连接
    [self connectToHost];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //失去交点的时候断开连接
    [self disconnectFromHost];
}
@end
