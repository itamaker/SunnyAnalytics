//
//  SAEventInfo.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAEventInfo : NSObject

@property(nonatomic,strong)NSString *operateType;
@property(nonatomic,strong)NSString *objId;
@property(nonatomic,strong)NSString *stayTime;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *operateDate;
@property(nonatomic,strong)NSString *appVersion;
@property(nonatomic,strong)NSString *productLine;
@property(nonatomic,strong)NSString *deviceID;
@property(nonatomic,strong)NSString *deviceModel;
@property(nonatomic,strong)NSString *deviceBrand;
@property(nonatomic,strong)NSString *deviceOSVersion;

- (NSDictionary *) entityToDictionary:(id)entity;

@end
