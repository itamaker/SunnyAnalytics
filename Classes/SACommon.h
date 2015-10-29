//
//  SACommon.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/10/29.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SACommon : NSObject{
     NSString *strBaseUrl;
     NSString *strChannelId;
}

@property(nonatomic,strong)NSString *baseUrl;

@property(nonatomic,strong)NSString *channelId;

+(SACommon*)shareInstance;

-(NSString*)deviceString;

-(NSString*)getCurrentDate;

@end
