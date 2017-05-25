//  SAAnalytics.m
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

#import "SAAnalytics.h"
#import "SAEventInfo.h"
#import "SAFileManeger.h"
#import "SAGzipUtility.h"
#import "SACommon.h"

#define BEHAVIOR_PATH @"behaviorInfo.txt"
#define VIEWINFO_PATH @"eventInfo.gz"
#define ERROR_PATH @"errorInfo.txt"
@implementation SAAnalytics

//lol, modify, do worry, not optimized,thanks friend.
+(instancetype)shareInstance
{
    static SAAnalytics *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+(void)initSAAnalytics:(NSString *)baseUrl  reportPolicy:(SAReportPolicy)reportPolicy channelId:(NSString *)channelId{
    
    [[SACommon shareInstance] setBaseUrl:baseUrl];
    [[SACommon shareInstance] setChannelId:channelId];
    [[SAAnalytics shareInstance] initWithReportPolicy:reportPolicy];
}

-(void)initWithReportPolicy:(SAReportPolicy)postPolicy{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSString *firstDate = [[SACommon  shareInstance ]getCurrentDate];
        
        [[NSUserDefaults standardUserDefaults] setObject:firstDate forKey:@"firstDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [self postDataThread];
}

//请不要关心下面的注释，因为这个项目还不完善.
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
    NSURL *url = [NSURL URLWithString:[SACommon shareInstance].baseUrl ];
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
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *result = [unarchiver decodeObjectForKey:@"ret"];
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
+(void)endPage:(NSString*)page{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"startFailed"]){
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


-(void)archiveEvent:(NSDictionary*)postDic{
    @synchronized(self)
    {
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_START"]) {
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
                
            userViewInfo.operateDate = [[SACommon shareInstance] getCurrentDate];
            userViewInfo.productLine = [NSString stringWithFormat:@"%d",(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"productLine"]];
            
            NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
            userViewInfo.appVersion = [NSString stringWithFormat:@"V%@",[dic objectForKey:@"CFBundleVersion"]];
            userViewInfo.deviceModel = [[SACommon shareInstance] deviceString];
            userViewInfo.appChannelId = [SACommon shareInstance].channelId;
            NSData *data = [SAFileManeger readFile:VIEWINFO_PATH];
            data = [SAGzipUtility decompressData:data];
                
            NSMutableArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (!arr) {
                arr = [[NSMutableArray alloc] init];
            }
            NSDictionary *viewData = [NSDictionary dictionary];
            viewData = [userViewInfo entityToDictionary:userViewInfo];
            
            [arr addObject:viewData];
            if ([SAFileManeger writeToFile:arr toPath:VIEWINFO_PATH]) {
                NSLog(@"写入成功");
            }else{
                NSLog(@"写入失败");
            }
        }
    }
}



-(NSInteger)caculateTimesBetween:(NSDate*)date1 withDate:(NSDate*)date2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger sec = [d hour]*3600+[d minute]*60+[d second];
    return sec;
}

@end
