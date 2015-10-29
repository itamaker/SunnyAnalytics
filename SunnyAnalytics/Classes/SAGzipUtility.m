//
//  SAGzipUtility.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import "SAGzipUtility.h"
#import <zlib.h>
@implementation SAGzipUtility

+(NSData *)compressData:(NSData *)uncompressedData
{
    if ([uncompressedData length] == 0) return uncompressedData;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[uncompressedData bytes];
    strm.avail_in = (unsigned int)[uncompressedData length];
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (unsigned int)([compressed length] - strm.total_out);
        deflate(&strm, Z_FINISH);
    } while (strm.avail_out == 0);
    deflateEnd(&strm);
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}
+ ( NSData *)decompressData:( NSData *)compressedData {
    
    z_stream zStream;
    
    zStream. zalloc = Z_NULL ;
    zStream. zfree = Z_NULL ;
    zStream. opaque = Z_NULL ;
    zStream. avail_in = 0 ;
    zStream. next_in = 0 ;
    
    int status = inflateInit2 (&zStream, ( 15 + 32 ));
    if (status != Z_OK ) {
        return nil ;
    }
    
    Bytef *bytes = ( Bytef *)[compressedData bytes ];
    NSUInteger length = [compressedData length ];
    NSUInteger halfLength = length/ 2 ;
    NSMutableData *uncompressedData = [ NSMutableData dataWithLength :length+halfLength];
    zStream. next_in = bytes;
    zStream. avail_in = ( unsigned int )length;
    zStream. avail_out = 0 ;
    NSInteger bytesProcessedAlready = zStream. total_out ;
    while (zStream. avail_in != 0 ) {
        if (zStream. total_out - bytesProcessedAlready >= [uncompressedData length ]) {
            [uncompressedData increaseLengthBy :halfLength];
        }
        zStream. next_out = ( Bytef *)[uncompressedData mutableBytes ] + zStream. total_out -bytesProcessedAlready;
        zStream. avail_out = ( unsigned int )([uncompressedData length ] - (zStream. total_out -bytesProcessedAlready));
        status = inflate (&zStream, Z_NO_FLUSH );
        if (status == Z_STREAM_END ) {
            break ;
        } else if (status != Z_OK ) {
            return nil ;
        }
    }
    
    status = inflateEnd (&zStream);
    if (status != Z_OK ) {
        return nil ;
    }
    [uncompressedData setLength : zStream. total_out -bytesProcessedAlready];  // Set real length
    return uncompressedData;
}
@end
