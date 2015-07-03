//
//  SCNewCell.m
//  AppNews
//
//  Created by SanChain on 15/6/19.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCNewCell.h"
#import "Colours.h"
#import "SCNewDemoItem.h"

@interface SCNewCell ()


@end

@implementation SCNewCell

- (void)awakeFromNib {
    self.founder.layer.cornerRadius = 3;
    self.founder.clipsToBounds = YES;
    
    self.likes.layer.cornerRadius = 3;
    self.likes.clipsToBounds = YES;
    self.likes.backgroundColor = [UIColor creamColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (id)newsCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCNewCell" owner:nil options:nil][0];
}

#pragma mark - 设置cell的内容
- (void)setDemoItem:(SCNewDemoItem *)demoItem
{
    _demoItem = demoItem;
    
    /** 点赞按钮 */
    [self.likes setTitle:demoItem.likes.description forState:UIControlStateNormal];
    
    /** 标题按钮 */
    self.title.text = demoItem.title;
    
    /** founder */
    if (demoItem.isfounder.integerValue > 0) {
        self.founder.hidden = NO;
    } else {
        self.founder.hidden = YES;
    }
    
    /** 描述 */
    self.intro.text = demoItem.intro;
    
    /** 发表时间 */
    NSDate *now = [NSDate date];
    NSTimeInterval nowInterval = [now timeIntervalSince1970];
    NSTimeInterval deltaTime = nowInterval - demoItem.inputtime.integerValue;
    NSInteger minutes = deltaTime / 60;
    NSInteger day = 24 * 60;
    NSInteger hour = 60;
    NSInteger minute = 1;
    
    if (minutes >= day) {
        self.inputTime.text = [NSString stringWithFormat:@"%zd天前", minutes/(60*24)];
    } else if (minutes >= hour && minutes < day){
        self.inputTime.text = [NSString stringWithFormat:@"%zd小时前", minutes/60];
    } else if (minutes > minute && minutes < hour) {
        self.inputTime.text = [NSString stringWithFormat:@"%zd分钟前", minutes];
    } else {
        self.inputTime.text = @"刚刚";
    }
}

#pragma mark - 监听点赞按钮
- (IBAction)clickLikesBtn:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSInteger likes = [self.demoItem.likes intValue];
    if (btn.selected) {
        [self.likes setImage:[UIImage imageNamed:@"toolbar_icon_like"] forState:UIControlStateNormal];
        NSString *like1 = [NSString stringWithFormat:@"%zd", likes+1];
        [self.likes setTitle:like1 forState:UIControlStateNormal];
        
    } else {
        NSString *like2 = [NSString stringWithFormat:@"%zd", likes];
        [self.likes setTitle:like2 forState:UIControlStateNormal];
        [self.likes setImage:[UIImage imageNamed:@"toolbar_icon_unlike"] forState:UIControlStateNormal];
    }
}
@end
