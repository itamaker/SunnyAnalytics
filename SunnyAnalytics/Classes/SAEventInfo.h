//
//  SAEventInfo.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAEventInfo : NSObject

/**
 * 事件名称
 */
@property(nonatomic,copy)NSString *operateType;
/**
 *  ID
 */
@property(nonatomic,copy)NSString *objId;
/**
 *  UIViewController停留的时间
 */
@property(nonatomic,copy)NSString *stayTime;
/**
 *  用户
 */
@property(nonatomic,copy)NSString *userName;
/**
 *  时间
 */
@property(nonatomic,copy)NSString *operateDate;
/**
 *  App版本
 */
@property(nonatomic,copy)NSString *appVersion;
/**
 *  渠道ID
 */
@property(nonatomic,copy)NSString *appChannelId;
/**
 *  工程线
 */
@property(nonatomic,copy)NSString *productLine;
/**
 *  UDID
 */
@property(nonatomic,copy)NSString *deviceID;
/**
 *  设备制式
 */
@property(nonatomic,copy)NSString *deviceModel;
/**
 *  设备OS版本
 */
@property(nonatomic,copy)NSString *deviceOSVersion;

/**
 *  系统转NSDictionary
 *
 *  @param entity 需要转换的entity
 *
 *  @return 转换后的NSDictionary
 */
- (NSDictionary *) entityToDictionary:(id)entity;

@end
