//
//  SAGzipUtility.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAGzipUtility : NSObject
//数据压缩

+(NSData *)compressData:(NSData *)uncompressedData;

// 数据解压缩

+ ( NSData *)decompressData:( NSData *)compressedData;

@end
