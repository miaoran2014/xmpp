//
//  MRLoginTool.h
//  xmpp
//
//  Created by admin on 15/4/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRLoginTool : NSObject
/**
 *  保存用户登录信息到用户偏好设置
 *
 *  @param user   用户名
 *  @param pwd    密码
 *  @param domain 域名
 */
+(void)saveLoginWithUser:(NSString *)user pwd:(NSString *)pwd domain:(NSString *)domain;


/**
 *  从偏好设置返回用户名
 */
+(NSString *)user;


/**
 *  从偏好设置返回密码
 */
+(NSString *)pwd;


/**
 *  从偏好设置返回域名
 */
+(NSString *)domain;

/**
 *  从偏好设置清除登录信息
 */
+(void)removeLoginInfo;


/**
 *  设置登录的状态到偏好设置
 *
 *  @param login YES :登录成功 NO:代表没有登录过
 */

+(void)setLoginStatu:(BOOL)login;

/**
 *  返回登录状态
 *
 *  @return YES :登录成功 NO:代表没有登录过
 */
+(BOOL)loginStatu;
@end
