//
//  NSDate+CZ.m
//  企信通
//
//  Created by Vincent_Guo on 14-7-13.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import "NSDate+CZ.h"


NSString *const CZDateFormatyyyyMMddHHmmss = @"yyyyMMddHHmmss";//年月日时分秒
NSString *const CZDateFormatMMddHHmmss = @"MMddHHmmss";//月日时分秒
NSString *const CZDateFormatHHmmss = @"HHmmss";//时分秒

@implementation NSDate (CZ)



+(NSString *)nowDateFormat:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:[NSDate date]];
}
@end
