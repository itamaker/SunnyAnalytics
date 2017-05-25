//  SAFileManeger.m
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

#import "SAFileManeger.h"
#import "SAGzipUtility.h"
@implementation SAFileManeger

+ (NSData*)readFile:(NSString *)toPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取真机下的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  // Documents
    //  stringByExpandingTildeInPath 将路径中的代字符扩展成用户主目录（~）或指定用户主目录（~user）
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:toPath];
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        return data;
    }
    return nil;
}

+ (BOOL)writeToFile:(NSArray*)arr toPath:(NSString*)toPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:toPath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    data = [SAGzipUtility compressData:data];
    return [data writeToFile:path atomically:NO];
}

+ (BOOL)deleteFile:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    // 找到path所在的路径
    NSString *topath = [documentsDirectory stringByAppendingPathComponent:path];
    NSData *data = [[NSData alloc] init];
    // 把空的数组写到path所在的位置，即删除了原来的path内容
    [data writeToFile:topath atomically:NO];
    return YES;
}
@end
