//
//  SCEverydayCell.m
//  AppNews
//
//  Created by SanChain on 15/6/17.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCEverydayCell.h"
#import "SCEverydayDemoItem.h"
#import "Colours.h"
#import "NSString+Extension.h"
#import "SCEverydayDemoFrame.h"


@interface SCEverydayCell ()
/** 点赞按钮 */
@property (nonatomic, weak) UIButton *likesBtn;
/** demo标题 */
@property (nonatomic, weak) UILabel *titleLab;
/** 是否创业者 */
@property (nonatomic, weak) UILabel *founderLab;
/** demo的描述 */
@property (nonatomic, weak) UILabel *introLab;
/** 评论按钮 */
@property (nonatomic, weak) UIButton *commentsBtn;
/** cell的分隔线 */
@property (nonatomic, weak) UIView *cellDivideLine;

@property (nonatomic, strong) SCEverydayDemoItem *demoItem;
@end

@implementation SCEverydayCell

- (SCEverydayDemoItem *)demoItem
{
    if (!_demoItem) {
        _demoItem = [[SCEverydayDemoItem alloc] init];
    }
    return _demoItem;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化一些子控件
        [self initCellSubview];
    }
    return self;
}

#pragma mark - 初始化cell的子控件
- (void)initCellSubview
{
    /** 点赞按钮 */
    UIButton *likesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likesBtn.titleLabel.font = SCLikesFont;
    [likesBtn setTitleColor:[UIColor black50PercentColor] forState:UIControlStateNormal];
    [likesBtn setImage:[UIImage imageNamed:@"toolbar_icon_unlike"] forState:UIControlStateNormal];
    likesBtn.imageEdgeInsets = UIEdgeInsetsMake(-13, 1.5, 0, 0);
    likesBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -20, 0, 0);
    likesBtn.layer.cornerRadius = 4;
    likesBtn.backgroundColor = [UIColor creamColor];
    // 监听按钮
    [likesBtn addTarget:self action:@selector(clickLikesBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:likesBtn];
    self.likesBtn = likesBtn;
    
    /** demo标题 */
    UILabel *titleLab = [[UILabel alloc] init];
    [self.contentView addSubview:titleLab];
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    /** 是否创业者 */
    UILabel *founderLab = [[UILabel alloc] init];
    [founderLab setBackgroundColor:[UIColor tomatoColor]];
    founderLab.layer.cornerRadius = 3;
    founderLab.clipsToBounds = YES;
    founderLab.font = SCFounderFont;
    founderLab.textColor = [UIColor whiteColor];
    founderLab.textAlignment = NSTextAlignmentCenter;
    founderLab.userInteractionEnabled = NO;
    [self.contentView addSubview:founderLab];
    self.founderLab = founderLab;
    
    /** demo的描述 */
    UILabel *introLab = [[UILabel alloc] init];
    introLab.numberOfLines = 0;
    introLab.font = SCTitleFont;
    [self.contentView addSubview:introLab];
    self.introLab = introLab;
    
    /** 评论按钮 */
    UIButton *commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentsBtn.titleLabel.font = SCCommentsFont;
    commentsBtn.enabled = NO;
    [commentsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    commentsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    commentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);    
    [commentsBtn setImage:[UIImage imageNamed:@"UMS_comment_normal_white"] forState:UIControlStateNormal];
    [self.contentView addSubview:commentsBtn];
    self.commentsBtn = commentsBtn;
    
    /** cell的分隔线 */
    UIView *divideLine = [[UIView alloc] init];
    [divideLine setBackgroundColor:[UIColor wheatColor]];
    [self.contentView addSubview:divideLine];
    self.cellDivideLine = divideLine;
}

#pragma mark - 设置子控件内容、frame
- (void)setDemoFrame:(SCEverydayDemoFrame *)demoFrame
{
    _demoFrame = demoFrame;
    SCEverydayDemoItem *demoItem = demoFrame.demoItem;
    self.demoItem = demoItem;
    
    // 设置各个子控件的内容、frame
    /** 点赞按钮 */
    [self.likesBtn setTitle: demoItem.likes.description forState: UIControlStateNormal];
    self.likesBtn.frame = demoFrame.likesBtnF;
    
    /** demo标题 */
    self.titleLab.text = demoItem.title;
    self.titleLab.frame = demoFrame.titleLabF;
    if ([self.titleLab.text isContainGraphema]) { // 英文title
        self.titleLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:SCTitleAttrFont];
    } else { // 中文title
        self.titleLab.font = [UIFont boldSystemFontOfSize:SCTitleAttrFont]; // 系统粗体

    }
    
    /** 是否创业者 */
    if (demoItem.isfounder.intValue) { // 是创业者
        self.founderLab.hidden = NO;
        self.founderLab.text = @"创";
        self.founderLab.frame = demoFrame.founderLabF;
    } else {
        self.founderLab.hidden = YES;
    }
    
    /** demo的描述 */
    self.introLab.text = demoItem.intro;
    self.introLab.frame = demoFrame.introLabF;
    
    /** 评论按钮 */
    [self.commentsBtn setTitle:demoItem.comments.description forState:UIControlStateNormal];
    self.commentsBtn.frame = demoFrame.commentsBtnF;
    
    /** cell的分隔线 */
    self.cellDivideLine.frame = demoFrame.cellDivideLineF;
}


#pragma mark - 监听点赞按钮
- (void)clickLikesBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSInteger likes = [self.demoItem.likes intValue];
    if (btn.selected) {
            [self.likesBtn setImage:[UIImage imageNamed:@"toolbar_icon_like"] forState:UIControlStateNormal];
            NSString *like1 = [NSString stringWithFormat:@"%zd", likes+1];
            [self.likesBtn setTitle:like1 forState:UIControlStateNormal];
        
    } else {
        NSString *like2 = [NSString stringWithFormat:@"%zd", likes];
        [self.likesBtn setTitle:like2 forState:UIControlStateNormal];
        [self.likesBtn setImage:[UIImage imageNamed:@"toolbar_icon_unlike"] forState:UIControlStateNormal];
    }
}


@end
