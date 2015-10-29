//
//  SAAnalytics.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {          //发送策略
    SABATCH = 0,          //Send Data When Start
    SAREALTIME = 1,       //RealTime Send Policy
    SAEVERYDAY = 2,       //EveryDay send Policy
} SAReportPolicy;

@interface SAAnalytics : NSObject

+(void)startWthReportPolicy:(SAReportPolicy)reportPolicy;
+(void)doEvent:(NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams;
+(void)beginPage:(NSString*)page;
+(void)endPage:(NSString*)page;

@end
