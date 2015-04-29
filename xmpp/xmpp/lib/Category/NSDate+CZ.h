//
//  NSDate+CZ.h
//  企信通
//
//  Created by Vincent_Guo on 14-7-13.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern常用于定义常量 其常量本身的内容在其它位置定义
extern NSString *const CZDateFormatyyyyMMddHHmmss;//年月日时分秒
extern NSString *const CZDateFormatMMddHHmmss;//月日时分秒
extern NSString *const CZDateFormatHHmmss;//时分秒

@interface NSDate (CZ)
/**
 *  返回格式式后的字符串 如果201401011212（年月时分秒）
 */
+(NSString *)nowDateFormat:(NSString *)format;

@end
