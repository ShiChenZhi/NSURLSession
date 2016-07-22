//
//  AFNetworking.m
//  NSURLSession网络请求的封装
//
//  Created by qianfeng on 16/7/12.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "AFNetworking.h"

@interface AFNetworking ()

@end

@implementation AFNetworking

/**
 GET请求方式
 */
+(void)getUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:url];
    
    //如果parameters是字典，则判断parameters是否有值
    if ([parameters allKeys]) {
        
        //参数通通过"？"与URL连接起来
        [mutableUrl appendString:@"？"];
        for (id key in parameters) {
            //获取键所对应的值
            NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            //通过这种格式与URL连接起来
            [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
        }
    }
//    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //请求对象
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:mutableUrl]];
    
    //会话对象
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    //会话任务
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            failureBlock(error);
        }
        else
        {
            //二进制数据转JSON数据
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(obj);
        }
    }];
    
    //执行会话任务
    [dataTask resume];
}

/**
 POST请求方式
 */
+(void)postUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    //请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //获取变格式后的签名串
    NSString *postStr = [AFNetworking parseData:parameters];
    
    //设置请求方式为POST
    request.HTTPMethod = @"POST";
    
    //设置请求体内容
    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //会话任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            failureBlock(error);
        }
        else
        {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(obj);
        }
    }];
    
    //执行会话任务
    [dataTask resume];
}

/**
 把字典的格式转成一定的URL格式
 */
+(NSString *)parseData:(NSDictionary *)dict
{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (id key in dict) {
        NSString *value = [[dict objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [result appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    
    return result;
}

@end
