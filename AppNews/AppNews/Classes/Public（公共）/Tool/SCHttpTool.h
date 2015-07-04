//
//  SCHttpTool.h
//  AppNews
//
//  Created by SanChain on 15/7/2.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHttpTool : NSObject

+ (void)GET:(NSString *)url params:(NSDictionary *)params timeoutInterval:(NSInteger)timeoutInterval success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


@end
