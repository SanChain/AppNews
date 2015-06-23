//
//  SCFlowLayout.m
//  AppNews
//
//  Created by SanChain on 15/6/20.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCFlowLayout.h"
#import "UIView+Extension.h"

/** item的间距 */
#define SCItemMargin 11
#define SCItemH 100
#define SCItemW (self.collectionView.frame.size.width - SCItemMargin * 3) / 2
@implementation SCFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    // item的尺寸
    self.itemSize = CGSizeMake(SCItemW, SCItemH);

    self.sectionInset = UIEdgeInsetsMake(SCItemMargin, SCItemMargin, SCItemMargin+2, SCItemMargin);
}

@end
