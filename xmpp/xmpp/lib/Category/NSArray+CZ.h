//
//  NSArray+CZ.h
//  D02-UISpliteViewController
//
//  Created by Vincent_Guo on 14-6-16.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CZ)

/**
 *  从主bundle获取数组 */
+(NSArray *)arrayWithPlistName:(NSString *) plistName;

@end
