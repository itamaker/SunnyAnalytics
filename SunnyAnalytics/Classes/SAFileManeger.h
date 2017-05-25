//  SAFileManeger.h
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
 *  gz文件管理
 */
@interface SAFileManeger : NSObject

/**
 *  读取toPath路径下的NSArray类型的内容
 *
 *  @param toPath 读取文件的路径
 *
 *  @return 返回文件data
 */
+ (NSData*)readFile:(NSString *)toPath;

/**
 *  NSArry写到toPath路径下
 *
 *  @param arr    NSArray数据
 *  @param toPath 写入路径
 *
 *  @return return 是否成功
 */
+ (BOOL)writeToFile:(NSArray*)arr toPath:(NSString*)toPath;

/**
 *  删除path内容
 *
 *  @param path 需要删除的文件路径
 *
 *  @return <#return value description#>
 */
+ (BOOL)deleteFile:(NSString*)path;

@end
