//
//  SCEverydayDemoFrame.h
//  AppNews
//
//  Created by SanChain on 15/6/17.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCEverydayDemoItem.h"


#define SCTitleFont [UIFont systemFontOfSize:14]
#define SCTitleAttrFont 14

#define SCFounderFont [UIFont systemFontOfSize:12]
#define SCLikesFont [UIFont systemFontOfSize:10]
#define SCCommentsFont [UIFont systemFontOfSize:10]

#define SCDeltaMargin 10 // cell边缘间距
#define SCLikeBtnW 23
#define SCLikeBtnH 35
#define SCCommentsW 40
#define SCCommentsH 15
#define SCFounderW 14
#define SCFounderH 14

@interface SCEverydayDemoFrame : NSObject

/** SCEverydayDemoItem模型 */
@property (nonatomic, strong) SCEverydayDemoItem *demoItem;

/** 点赞按钮的frame */
@property (nonatomic, assign) CGRect likesBtnF;

/** demo标题的frame */
@property (nonatomic, assign) CGRect titleLabF;

/** 是否创业者的frame */
@property (nonatomic, assign) CGRect founderLabF;

/** demo的描述的frame */
@property (nonatomic, assign) CGRect introLabF;

/** 评论按钮的frame */
@property (nonatomic, assign) CGRect commentsBtnF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** cell的分隔线 */
@property (nonatomic, assign) CGRect cellDivideLineF;


@end
