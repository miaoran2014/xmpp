//
//  NSArray+CZ.m
//  D02-UISpliteViewController
//
//  Created by Vincent_Guo on 14-6-16.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import "NSArray+CZ.h"

@implementation NSArray (CZ)

+(NSArray *)arrayWithPlistName:(NSString *)plistName{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@".plist"];
    
    return [NSArray arrayWithContentsOfFile:plistPath];
}

@end
