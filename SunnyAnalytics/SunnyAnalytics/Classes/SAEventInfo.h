//
//  SAEventInfo.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAEventInfo : NSObject

@property(nonatomic,retain)NSString *operateType;
@property(nonatomic,retain)NSString *objId;
@property(nonatomic,retain)NSString *stayTime;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *operateDate;
@property(nonatomic,retain)NSString *appVersion;
@property(nonatomic,retain)NSString *productLine;
@property(nonatomic,retain)NSString *deviceID;
@property(nonatomic,retain)NSString *deviceModel;
@property(nonatomic,retain)NSString *deviceBrand;
@property(nonatomic,retain)NSString *deviceOSVersion;
- (NSDictionary *) entityToDictionary:(id)entity;

@end
