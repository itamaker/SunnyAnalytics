//  SAEventInfo.h
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
