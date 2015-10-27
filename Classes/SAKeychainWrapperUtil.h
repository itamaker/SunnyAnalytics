//
//  SAKeychainWrapperUtil.h
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"
@interface SAKeychainWrapperUtil : NSObject
@property (nonatomic , strong) KeychainItemWrapper * keyChainItemWrapper;

+ (id) sharedInstance;

- (void)initKeychainWrapperWithIdentifier:(NSString *) identifier;
@end
