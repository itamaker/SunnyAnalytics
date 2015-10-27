//
//  SAAnalytics.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//
#import "SAAnalytics.h"
#import "SAEventInfo.h"
#import "SAUDIDUtil.h"
#import <net/if.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/utsname.h>
#import "SAFileManeger.h"
#import "SAGzipUtility.h"
#import "SAHeader.h"
#import "JSONKit.h"
#import "SAUDIDUtil.h"
#include "SAKeychainWrapperUtil.h"

#define BEHAVIOR_PATH @"behaviorInfo.txt"
#define VIEWINFO_PATH @"eventInfo.gz"
#define ERROR_PATH @"errorInfo.txt"
@implementation SAAnalytics
+(SAAnalytics*)shareInstance
{
    static SAAnalytics *instance = nil;
    if (instance == nil) {
        instance = [[[self class] alloc] init];
    }
    return instance;
}
+(void)startWthReportPolicy:(SAReportPolicy)reportPolicy
{
    [[SAAnalytics shareInstance] initWithReportPolicy:reportPolicy];
}
-(void)initWithReportPolicy:(SAReportPolicy)postPolicy
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSString *firstDate = [self getCurrentDate];
        
        [[NSUserDefaults standardUserDefaults] setObject:firstDate forKey:@"firstDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    
    
    
    
    
    [self postDataThread];
    //performSelectorInBackground开多线程
//    [self performSelectorInBackground:@selector(combinData) withObject:nil];
}
-(void)postData
{
//    NSString *fileName = @"hmt";
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@"operate" forKey:@"operateType"];
//    NSArray *arr = @[dic];
//    
//    [SAFileManeger writeToFile:arr toPath:VIEWINFO_PATH];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取真机下的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];  // Documents
    //  stringByExpandingTildeInPath 将路径中的代字符扩展成用户主目录（~）或指定用户主目录（~user）
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:VIEWINFO_PATH];
    //  确定需要上传的文件(假设选择本地的文件)
    NSURL*theurl=[NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:theurl];
    NSURL *url = [NSURL URLWithString:SAUPLOADLOG_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    
    //    [request setHTTPBody:[data base64EncodedDataWithOptions:NSUTF8StringEncoding]];
    //    [request setValue:@"" forKey:@"Content-Type"];
    //    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadLog\"; filename=\"vim_go.gz\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request  setHTTPBody:body];
    //    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSDictionary *result = [data objectFromJSONData];
        NSNumber *ret = [result objectForKey:@"ret"];
        if (ret.integerValue==0&&data) {
            NSLog(@"发送成功%@",result);
            [SAFileManeger deleteFile:VIEWINFO_PATH];
        }
        else
        {
            NSLog(@"发送失败");
        }
        
    }];
}

-(void)postDataThread{
    
    
    NSData *viewInfoArray = [SAFileManeger readFile:VIEWINFO_PATH];  //页面访问信息
    
//    NSString *eventResponse;
//    NSString *viewResponse;
//    NSString *errorResponse;
    [self postData];
    if (viewInfoArray) {
//        [message setObject:@"01" forKey:@"operateType"];
//        eventResponse = [XHPostData postEventInfo:eventArray withPostMessage:message];
    }
    
}

+(void)doEvent:(NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    if (operateType) {
        [dic setObject:operateType forKey:@"operateType"];
    }
    
    if (objId) {
        [dic setObject:objId forKey:@"objId"];
    }
    if (optParams) {
        [dic setObject:optParams forKey:@"optParams"];
    }
    [dic setObject:[NSDate date] forKey:@"startDate"];
    //修改过
    NSLog(@"%@",dic);
    [[SAAnalytics shareInstance] performSelectorInBackground:@selector(archiveEvent:) withObject:dic];
}
+(void)beginPage:(NSString*)page
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"startFailed"])
    {
//        [[NSUserDefaults standardUserDefaults] setObject:page forKey:@"page"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[NSString stringWithFormat:@"%@startDate",page]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }

}
+(void)endPage:(NSString*)page
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"startFailed"])
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *stayTimeinteval;
        
        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@startDate",page]];
        NSInteger intimer = [[SAAnalytics shareInstance] caculateTimesBetween:date withDate:[NSDate date]];
        stayTimeinteval = [NSString stringWithFormat:@"%ld",(long)intimer];
            
        if (stayTimeinteval) {
            [params setObject:page forKey:@"operateType"];
            [params setObject:stayTimeinteval forKey:@"optParams"];
            [[NSUserDefaults standardUserDefaults] setObject:page forKey:@"fromPage"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRST_START"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@startDate",page]];
            [[SAAnalytics shareInstance] performSelectorInBackground:@selector(archiveEvent:) withObject:params];
        }
        
        
    }
}


-(void)archiveEvent:(NSDictionary*)postDic
{
    
    @synchronized(self)
    {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"fromPage"]&&![[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_START"]) {
            SAEventInfo *userViewInfo = [[SAEventInfo alloc]init];
            
            userViewInfo.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
            if (!userViewInfo.userName) {
                userViewInfo.userName = @"";
            }
            if ([postDic objectForKey:@"operateType"]) {
                userViewInfo.operateType = [postDic objectForKey:@"operateType"];
            }
            else userViewInfo.operateType = @"";
                
            if ([postDic objectForKey:@"optParams"]) {
                    userViewInfo.stayTime = [postDic objectForKey:@"optParams"];
                }
            else
                userViewInfo.stayTime = @"";
            if ([postDic objectForKey:@"objId"]) {
                userViewInfo.objId = [postDic objectForKey:@"objId"];
            }
            else
                userViewInfo.objId = @"";
            
            userViewInfo.operateDate = [self getCurrentDate];
                userViewInfo.productLine = [NSString stringWithFormat:@"%d",(int)[[NSUserDefaults standardUserDefaults] integerForKey:SAProductLine]];
            
            NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
            userViewInfo.deviceID = [SAUDIDUtil UDID];
            userViewInfo.appVersion = [NSString stringWithFormat:@"V%@",[dic objectForKey:@"CFBundleVersion"]];
            userViewInfo.deviceBrand = [UIDevice currentDevice].model;
            userViewInfo.deviceModel = [self deviceString];
            userViewInfo.deviceOSVersion = [UIDevice currentDevice].systemVersion;
            NSData *data = [SAFileManeger readFile:VIEWINFO_PATH];
                data = [SAGzipUtility decompressData:data];
                
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[data objectFromJSONData]];
            if (!arr) {
                arr = [[NSMutableArray alloc] init];
            }
            NSDictionary *viewData = [NSDictionary dictionary];
            viewData = [userViewInfo entityToDictionary:userViewInfo];
            
            [arr addObject:viewData];
                if ([SAFileManeger writeToFile:arr toPath:VIEWINFO_PATH]) {
                    NSLog(@"写入成功");
                }
                else
                {
                    NSLog(@"写入失败");
                }
                
//            if (isDebugEnabled) {
//                [self postDataToServer];
//            }
        }
        
    }
}
-(NSString*)getCurrentDate
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    
    return locationString;
}
//根据获取到的modalArray数组中的内容，对应的找到modelNameArray数组中的名称（即实际中使用的名字）
-(NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //    modalArray和modalNameArray中的内容是一一对应的
    //    modalArray中的内容是根据系统信息得到的，modalNameArray中的内容是实际中使用的名字
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,1",
                            @"iPhone7,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            @"iPad4,1",
                            @"iPad4,2",
                            @"iPad4,3",
                            @"iPad4,4",
                            @"iPad4,5",
                            @"iPad4,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iPhone 5s(GSM)",
                                @"iPhone 5s(Global)",
                                @"iPhone 6 Plus",
                                @"iPhone 6",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                @"iPad Air(WiFi)",
                                @"iPad Air(GSM)",
                                @"iPad Air(GSM+CDMA)",
                                @"iPad Mini 2G(WiFi)",
                                @"iPad Mini 2G(GSM)",
                                @"iPad Mini 2G(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    
    
    
    
    return modelNameString;
}
-(NSInteger)caculateTimesBetween:(NSDate*)date1 withDate:(NSDate*)date2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    
    NSInteger sec = [d hour]*3600+[d minute]*60+[d second];
    return sec;
}

@end
