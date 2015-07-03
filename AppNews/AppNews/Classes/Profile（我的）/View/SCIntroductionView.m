//
//  SCIntroductionView.m
//  AppNews
//
//  Created by SanChain on 15/6/21.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCIntroductionView.h"
#import "MJExtension.h"
#import "Colours.h"
#import "SCProfileIntroduction.h"

@implementation SCIntroductionView

+ (instancetype)loadIntroductionView
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCIntroductionView" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor creamColor];

    // plist 转模型
    SCProfileIntroduction *profileIntro = [SCProfileIntroduction objectWithFilename:@"ProfileInformation.plist"];
    self.nickL.text = profileIntro.nickname;
    self.introL.text = profileIntro.intro;
    self.nickImgView.layer.cornerRadius = 30;
    self.nickImgView.clipsToBounds = YES;
    
    self.profileIntro = profileIntro;
    
}

@end
