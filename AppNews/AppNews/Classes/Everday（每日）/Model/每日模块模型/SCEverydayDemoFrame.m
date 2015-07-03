//
//  SCEverydayDemoFrame.m
//  AppNews
//
//  Created by SanChain on 15/6/17.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCEverydayDemoFrame.h"
#import "NSString+Extension.h"
#import "SCEverydayDemoItem.h"

@implementation SCEverydayDemoFrame

#pragma mark - 计算各个子控件的frame
- (void)setDemoItem:(SCEverydayDemoItem *)demoItem
{
    _demoItem = demoItem;
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    // 根据模型数据计算各个子控件的frame
    
    /** 点赞按钮的frame */
    CGFloat likesX = SCDeltaMargin;
    CGFloat likesY = SCDeltaMargin * 1.5;
    CGFloat likesW = SCLikeBtnW;
    CGFloat likesH = SCLikeBtnH;
    self.likesBtnF = CGRectMake(likesX, likesY, likesW, likesH);
    
    /** demo标题的frame */
    CGFloat titleX = CGRectGetMaxX(self.likesBtnF) + SCDeltaMargin;
    CGFloat titleY = likesY + 4;
    CGSize titleWH = [demoItem.title sizeWithfont:SCTitleFont maxW:cellW];
    self.titleLabF = CGRectMake(titleX, titleY, titleWH.width, titleWH.height);
    
    /** 是否创业者的frame */
    CGFloat founderX = CGRectGetMaxX(self.titleLabF) + SCDeltaMargin;
    CGFloat founderY = titleY;
    CGFloat founderW = SCFounderW;
    CGFloat founderH = SCFounderH;
    self.founderLabF = CGRectMake(founderX, founderY, founderW, founderH);
    
    /** demo的描述的frame */
    CGFloat introX = titleX;
    CGFloat introY = CGRectGetMaxY(self.titleLabF) + SCDeltaMargin - 3;
    CGSize introWH = [demoItem.intro sizeWithfont:SCTitleFont maxW:(cellW - CGRectGetMaxX(self.likesBtnF) - 3 *SCDeltaMargin)];
    self.introLabF = CGRectMake(introX, introY, introWH.width, introWH.height);
    
    /** 评论按钮的frame */
    CGFloat CommentsY = titleY;
    CGFloat CommentsW = SCCommentsW;
    CGFloat CommentsH = SCCommentsH;
    CGFloat CommentsX = cellW - 2 * SCDeltaMargin - CommentsW;
    self.commentsBtnF = CGRectMake(CommentsX, CommentsY, CommentsW, CommentsH);
    
    /** cell的分隔线 */
    CGFloat divideLineY = CGRectGetMaxY(self.introLabF) + 2 * SCDeltaMargin;
    CGFloat divideLineW = CGRectGetMaxX(self.commentsBtnF) - likesX;
    self.cellDivideLineF = CGRectMake(likesX, divideLineY, divideLineW, 0.8);
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.cellDivideLineF) + 1;
}

@end
