//
//  SAUDIDUtil.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//
#import "SAUDIDUtil.h"
#import <Security/Security.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include "SAKeychainWrapperUtil.h"
#import "SAHeader.h"

@implementation SAUDIDUtil

+ (NSString *)UDID
{
    [[SAKeychainWrapperUtil sharedInstance] initKeychainWrapperWithIdentifier:SAUUIDKey];
    KeychainItemWrapper * wrapper = [[SAKeychainWrapperUtil sharedInstance] keyChainItemWrapper];
    NSString * udid = [wrapper objectForKey:(__bridge id)kSecValueData];
    if (!udid || [@""isEqualToString:udid]) {
        NSString * sytemVersion = [[UIDevice currentDevice] systemVersion];
        CGFloat version = [sytemVersion floatValue];
        if (version >= 7.0f) {
            udid = [SAUDIDUtil UDID_IOS7];
        }
        else if (version >= 4.0){
            udid = [SAUDIDUtil UDID_IOS6];
        }
        [wrapper setObject:udid forKey:(__bridge id)kSecValueData];
    }
    return udid;
}

+ (NSString *)UDID_IOS7
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)UDID_IOS6
{
    return [SAUDIDUtil macAddress];
}

+ (NSString *)macAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = nil;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        if (msgBuffer) {
            free(msgBuffer);
        }
        
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}
@end
