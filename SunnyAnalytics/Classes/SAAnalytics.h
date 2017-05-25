//  SAAnalytics.h
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
 发送策略
 */
typedef enum {
    SABATCH = 0,          //Send Data When Start
    SAREALTIME = 1,       //RealTime Send Policy
    SAEVERYDAY = 2,       //EveryDay send Policy
} SAReportPolicy;

@interface SAAnalytics : NSObject

/**
 *  初始化数据统计
 *
 *  @param baseUrl      埋点上传URL
 *  @param reportPolicy 发送策略
 *  @param channelId    渠道ID
 */
+(void)initSAAnalytics:(NSString *)baseUrl  reportPolicy:(SAReportPolicy)reportPolicy channelId:(NSString *) channelId;

/**
 *  按钮事件统计
 *
 *  @param operateType 名称
 *  @param objId       ID
 *  @param optParams   参数
 */
+(void)doEvent:(NSString*)operateType objectId:(NSString*)objId params:(NSString*)optParams;

/**
 *  UIViewController 创建时调用
 *
 *  @param page UIViewController名称
 */
+(void)beginPage:(NSString*)page;

/**
 *  UIViewController 销毁时调用
 *
 *  @param page UIViewController名称
 */
+(void)endPage:(NSString*)page;

@end
