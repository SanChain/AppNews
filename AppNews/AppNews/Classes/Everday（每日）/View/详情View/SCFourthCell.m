//
//  SCFourthCell.m
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCFourthCell.h"
#import "SCDetailCommentsData.h"
#import "UIButton+WebCache.h"
#import "SCDetailCommentsData.h"

@interface SCFourthCell ()
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@end
@implementation SCFourthCell

- (void)awakeFromNib {

    self.icon.layer.cornerRadius = 10;
    self.icon.clipsToBounds = YES;
    self.title.layer.cornerRadius = 3;
    self.title.clipsToBounds = YES;
}


// 加载xib
+ (instancetype)loadFourthCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCDetailFirstCell" owner:nil options:nil][2];
}

// 实例化可重用的cell
+ (instancetype)loadNewCellWithTableView:(UITableView *)tableView
{
    SCFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourthCell"];
    [tableView registerNib:[UINib nibWithNibName:@"SCDetailFirstCell" bundle:nil] forCellReuseIdentifier:@"fourthCell"];
    if (cell == nil) {
        cell = [self loadFourthCell];
        
    }
    return cell;
}


- (void)setCommentsData:(SCDetailCommentsData *)commentsData
{
    _commentsData = commentsData;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:commentsData.author_avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
    
    self.title.text = commentsData.author_name;
    self.comment.text = commentsData.message;
}

@end
