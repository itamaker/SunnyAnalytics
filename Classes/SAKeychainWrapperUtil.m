//
//  SAKeychainWrapperUtil.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//


#import "SAKeychainWrapperUtil.h"

static SAKeychainWrapperUtil * _instance = nil;
@implementation SAKeychainWrapperUtil

+ (id) sharedInstance{
    if (!_instance){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[SAKeychainWrapperUtil alloc] init];
        });
    }
    return _instance;
}


- (void) initKeychainWrapperWithIdentifier:(NSString *)identifier
{
    // accessGroup这个为什么要设置成nil？ 如果不设置成nil在真机调试时会报错
    // KeychainAccessGroups.plist 这个文件如果在签名时加到code sign entitlement 里面会签名验证通不过 ， 说找不到KeychainAccessGroups.plist ，这个文件应该放到什么位置？
    // OMG...
    self.keyChainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:identifier
                                                                   accessGroup:nil];
}
@end
