//
//  SCOptionMenuView.m
//  AppNews
//
//  Created by SanChain on 15/6/21.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCOptionMenuView.h"

@implementation SCOptionMenuView
/** 加载xib */
+ (id)loadOptionMenuView
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCOptionMenuView" owner:nil options:nil][0];
    
}


#pragma mark 监听点赞产品按钮
- (IBAction)clickLikesBtn:(UIButton *)sender {
    // 设置按钮及按钮上面文本的颜色
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.publishBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];
    self.likesL.textColor = [UIColor orangeColor];
    self.publishL.textColor = [UIColor lightGrayColor];
    self.commentL.textColor = [UIColor lightGrayColor];

    // 发通知给控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LikesBtn" object:nil userInfo:nil];
}

#pragma mark 监听发布产品按钮
- (IBAction)clickPublishBtn:(id)sender {
    // 设置按钮及按钮上面文本的颜色
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.likesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.commentBtn setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];
    self.likesL.textColor = [UIColor lightGrayColor];
    self.publishL.textColor = [UIColor orangeColor];
    self.commentL.textColor = [UIColor lightGrayColor];
    
    // 发通知给控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PublishBtn" object:nil userInfo:nil];
}

#pragma mark 监听评论产品按钮
- (IBAction)clickCommentBtn:(id)sender {
    // 设置按钮及按钮上面文本的颜色
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.likesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.publishBtn setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];
    self.likesL.textColor = [UIColor lightGrayColor];
    self.publishL.textColor = [UIColor lightGrayColor];
    self.commentL.textColor = [UIColor orangeColor];
    
    // 发通知给控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentBtn" object:nil userInfo:nil];
}


@end
