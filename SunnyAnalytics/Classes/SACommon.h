//  SACommon.h
//Copyright (c) 2015-2017 Sunny Software Foundation
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#import <Foundation/Foundation.h>

/**
 *  工具类
 */
@interface SACommon : NSObject{
     NSString *strBaseUrl;
     NSString *strChannelId;
}

/**
 *  上传gz文件地址
 */
@property(nonatomic,strong)NSString *baseUrl;

/**
 *  渠道号
 */
@property(nonatomic,strong)NSString *channelId;

+(SACommon*)shareInstance;

/**
 *  获取设备名称
 *
 *  @return 设备名称
 */
-(NSString*)deviceString;

/**
 *  获取当前系统时间
 *
 *  @return 系统时间
 */
-(NSString*)getCurrentDate;

@end
