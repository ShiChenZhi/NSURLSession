//
//  AFNetworking.h
//  NSURLSession网络请求的封装
//
//  Created by qianfeng on 16/7/12.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 成功的Block，参数类型其实是字典类型(大多数情况下)
 */
typedef void (^SuccessBlock)(id obj);

/**
 失败的Block
 */
typedef void (^FailureBlock)(NSError *error);

@interface AFNetworking : NSObject

/**
 参数一：请求路径
 参数二：给定的URL需要的参数，nil则为无参数
 */
+(void)getUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+(void)postUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;


@end
