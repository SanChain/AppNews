//
//  SCAccount.h
//  AppNews
//
//  Created by SanChain on 15/6/16.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAccount : NSObject <NSCoding>
@property (nonatomic, copy) NSString *loginAccount;
@property (nonatomic, copy) NSString *loginPassword;

@end
