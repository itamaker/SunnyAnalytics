//
//  SACommon.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/10/29.
//  Copyright © 2015年 gitpark. All rights reserved.
//

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
