//
//  AppDelegate.h
//  xmpp
//
//  Created by admin on 15/4/28.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


//定义登录结果的枚举
typedef enum {
    XMPPResultTypeLogining,//登录中
    XMPPResultTypeLoginSuccuess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetError,//网络问题 (不给力)
    XMPPResultTypeUnknowDomain,//主机不存在
    XMPPResultTypeConnectionRefused,//服务器没有开启，拒绝连接
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
    
}XMPPResultType;
//定义登录结果的block
typedef void (^XMPPResultBlock)(XMPPResultType resultType);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign,getter = isUserRegister) BOOL userRegister;//用户登录和注册的标识 YES:注册 NO:登录

//连接到服务器 用户登录
-(void)xmppLogin:(XMPPResultBlock)resultBlock;

//用户注销
-(void)xmppLogout;
//连接到服务器 用户注册
-(void)xmppRegister:(XMPPResultBlock)resultBlock;
@end

