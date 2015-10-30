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
@property(nonatomic,strong)NSString *operateType;
/**
 *  ID
 */
@property(nonatomic,strong)NSString *objId;
/**
 *  UIViewController停留的时间
 */
@property(nonatomic,strong)NSString *stayTime;
/**
 *  用户
 */
@property(nonatomic,strong)NSString *userName;
/**
 *  时间
 */
@property(nonatomic,strong)NSString *operateDate;
/**
 *  App版本
 */
@property(nonatomic,strong)NSString *appVersion;
/**
 *  渠道ID
 */
@property(nonatomic,strong)NSString *appChannelId;
/**
 *  工程线
 */
@property(nonatomic,strong)NSString *productLine;
/**
 *  UDID
 */
@property(nonatomic,strong)NSString *deviceID;
/**
 *  设备制式
 */
@property(nonatomic,strong)NSString *deviceModel;
/**
 *  设备OS版本
 */
@property(nonatomic,strong)NSString *deviceOSVersion;

/**
 *  系统转NSDictionary
 *
 *  @param entity 需要转换的entity
 *
 *  @return 转换后的NSDictionary
 */
- (NSDictionary *) entityToDictionary:(id)entity;

@end
