//
//  SCSecondCell.m
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCSecondCell.h"
#import "Colours.h"

@interface SCSecondCell ()
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *founderL;
@property (weak, nonatomic) IBOutlet UILabel *introL;
- (IBAction)clickBtn:(id)sender;

@end

@implementation SCSecondCell

- (void)awakeFromNib {
    self.likesBtn.layer.cornerRadius = 3;
    self.likesBtn.clipsToBounds = YES;
    self.likesBtn.backgroundColor = [UIColor creamColor];

    self.founderL.layer.cornerRadius = 3;
    self.founderL.clipsToBounds = YES;

}


// 加载xib
+ (instancetype)loadSecondCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCDetailFirstCell" owner:nil options:nil][1];
}

// 实例化可重用的cell
+ (SCSecondCell *)loadNewCellWithTableView:(UITableView *)tableView
{
    SCSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
    if (cell == nil) {
        cell = [self loadSecondCell];
        [tableView registerNib:[UINib nibWithNibName:@"SCDetailFirstCell" bundle:nil] forCellReuseIdentifier:@"secondCell"];
    }
    return cell;
}

#pragma mark 设置cell内容
- (void)setDetailDemo:(SCDetailDemo *)detailDemo
{
    _detailDemo = detailDemo;
    
    /** 点赞按钮 */
    [self.likesBtn setTitle:detailDemo.likes.description forState:UIControlStateNormal];
    
    /** 标题按钮 */
    self.titleL.text = detailDemo.title;
    
    /** founder */
    if (detailDemo.isfounder.integerValue > 0) {
        self.founderL.hidden = NO;
    } else {
        self.founderL.hidden = YES;
    }
    
    /** 描述 */
    self.introL.text = detailDemo.intro;
}

- (IBAction)clickBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSInteger likes = [self.detailDemo.likes intValue];
    if (sender.selected) {
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
