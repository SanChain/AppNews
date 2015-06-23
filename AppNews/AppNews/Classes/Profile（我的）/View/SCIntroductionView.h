//
//  SCIntroductionView.h
//  AppNews
//
//  Created by SanChain on 15/6/21.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCProfileIntroduction.h"

@interface SCIntroductionView : UIView
/** 加载xib */
+ (id)loadIntroductionView;
@property (weak, nonatomic) IBOutlet UIImageView *nickImgView;
@property (weak, nonatomic) IBOutlet UILabel *introL;
@property (weak, nonatomic) IBOutlet UILabel *nickL;

@property (nonatomic, strong) SCProfileIntroduction *profileIntro;

@end
