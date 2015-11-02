//
//  SAGzipUtility.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  gz文件解压缩
 */
@interface SAGzipUtility : NSObject

/**
 *  数据压缩
 *
 *  @param uncompressedData 需要压缩的data包
 *
 *  @return 返回压缩后的data包
 */
+(NSData *)compressData:(NSData *)uncompressedData;

/**
 *  数据解压缩
 *
 *  @param compressedData 需要解压缩的data包
 *
 *  @return 解压后的data包
 */
+ ( NSData *)decompressData:( NSData *)compressedData;

@end
