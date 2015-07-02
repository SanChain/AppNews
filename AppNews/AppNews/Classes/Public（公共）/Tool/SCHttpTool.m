//
//  SCHttpTool.m
//  AppNews
//
//  Created by SanChain on 15/7/2.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCHttpTool.h"
#import "AFNetworking.h"

@implementation SCHttpTool

#pragma mark 封装AFN的GET请求
/**
 *  封装AFN的GET请求
 *
 *  @param url             请求地址
 *  @param params          请求参数
 *  @param timeoutInterval 请求超时的时间
 *  @param success         请求成功执行的block
 *  @param failure         请求失败执行的block
 */
+ (void)GET:(NSString *)url params:(NSDictionary *)params timeoutInterval:(NSInteger)timeoutInterval success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc] init];
    mgr.requestSerializer.timeoutInterval = timeoutInterval;
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
