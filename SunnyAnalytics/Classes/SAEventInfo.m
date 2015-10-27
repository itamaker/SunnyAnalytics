//
//  SAEventInfo.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright (c) 2015年 gitpark. All rights reserved.
//

#import "SAEventInfo.h"
#import <objc/runtime.h>
@implementation SAEventInfo


-(NSDictionary*)entityToDictionary:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

- (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self entityToDictionary:obj];
}


//- (NSDictionary *) entityToDictionary:(id)entity
//{
//    
//    Class clazz = [entity class];
//    u_int count;
//    
//    objc_property_t* properties = class_copyPropertyList(clazz, &count);
//    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
//    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
//    
//    for (int i = 0; i < count ; i++)
//    {
//        objc_property_t prop=properties[i];
//        const char* propertyName = property_getName(prop);
//        
//        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
//        
//        //        const char* attributeName = property_getAttributes(prop);
//        //        NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
//        //        NSLog(@"%@",[NSString stringWithUTF8String:attributeName]);
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        id value =  [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
//#pragma clang diagnostic pop
//        if(value ==nil)
//            [valueArray addObject:[NSNull null]];
//        else {
//            [valueArray addObject:value];
//        }
//        //        NSLog(@"%@",value);
//    }
//    
//    free(properties);
//    
//    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
//    NSLog(@"%@", returnDic);
//    
//    return returnDic;
//}

@end
