//
//  MRLoginTool.m
//  xmpp
//
//  Created by admin on 15/4/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "MRLoginTool.h"

#define kUserKey @"user" //用户名
#define kPwdKey @"pwd" //密码
#define kDomainKey @"domain" //域名
#define kIsLoginKey @"isLogin" //是否登录过

@implementation MRLoginTool
+(void)saveLoginWithUser:(NSString *)user pwd:(NSString *)pwd domain:(NSString *)domain{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:kUserKey];
    [defaults setObject:pwd forKey:kPwdKey];
    [defaults setObject:domain forKey:kDomainKey];
    //同步沙盒
    [defaults synchronize];
}

/**
 *  从偏好设置返回用户名
 */
+(NSString *)user{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserKey];
}


/**
 *  从偏好设置返回密码
 */
+(NSString *)pwd{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPwdKey];
}


/**
 *  从偏好设置返回域名
 */
+(NSString *)domain{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDomainKey];
}


#pragma mark 消除沙盒用户登录数据
+(void)removeLoginInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserKey];
    [defaults removeObjectForKey:kPwdKey];
    [defaults removeObjectForKey:kDomainKey];
    [defaults synchronize];
}
/**
 *  设置登录的状态到偏好设置
 *
 *  @param login YES :登录成功 NO:代表没有登录过
 */
+(void)setLoginStatu:(BOOL)login{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:login forKey:kIsLoginKey];
    [defaults synchronize];
}

/**
 *  返回登录状态
 *
 *  @return YES :登录成功 NO:代表没有登录过
 */
+(BOOL)loginStatu{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIsLoginKey];
}

@end
