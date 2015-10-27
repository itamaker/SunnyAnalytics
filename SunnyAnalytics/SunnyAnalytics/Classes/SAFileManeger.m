//
//  SAFileManeger.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import "SAFileManeger.h"
#import "SAGzipUtility.h"
#import "JSONKit.h"
@implementation SAFileManeger
//读取toPath路径下的NSArray类型的内容
+ (NSData*)readFile:(NSString *)toPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取真机下的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  // Documents
    //  stringByExpandingTildeInPath 将路径中的代字符扩展成用户主目录（~）或指定用户主目录（~user）
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:toPath];
    //    NSString *home = NSHomeDirectory();
    //    NSString*path = [home stringByAppendingPathComponent:@"in.txt"];
    if ([fileManager fileExistsAtPath:path]) {
//        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:path];
        NSData *data = [NSData dataWithContentsOfFile:path];
        //        NSData *reader = [NSData dataWithContentsOfFile:path];
        return data;
        
    }
    return nil;
    
}

//是否把arr写到toPath路径下
+ (BOOL)writeToFile:(NSArray*)arr toPath:(NSString*)toPath
{
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:toPath];
    //    NSString *home = NSHomeDirectory();
    //
    //    NSString*path = [home stringByAppendingPathComponent:@"in.plist"];
    
    
    //    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"userInfo.plist"];
    NSData *data = [arr JSONData
                    ];
    data = [SAGzipUtility compressData:data];
    
    return [data writeToFile:path atomically:NO];
    
    
    
}

//是否删除path内容
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
    //    return [fileManager removeItemAtPath:topath error:nil];
    return YES;
}
@end
