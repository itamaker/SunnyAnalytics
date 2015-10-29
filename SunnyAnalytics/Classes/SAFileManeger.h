//
//  SAFileManeger.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAFileManeger : NSObject

+ (NSData*)readFile:(NSString *)toPath;

+ (BOOL)writeToFile:(NSArray*)arr toPath:(NSString*)toPath;

+ (BOOL)deleteFile:(NSString*)path;

@end
