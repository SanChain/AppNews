//
//  SCDetailFirstCell.m
//  AppNews
//
//  Created by SanChain on 15/6/24.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCDetailFirstCell.h"
#import "UIImageView+WebCache.h"

@interface SCDetailFirstCell ()
/** 作者头像按钮 */
@property (weak, nonatomic) IBOutlet UIImageView *authorImgView;

/** 作者名字 */
@property (weak, nonatomic) IBOutlet UILabel *authorName;
/** 作者描述 */
@property (weak, nonatomic) IBOutlet UILabel *authorDesc;
/** 监听头像按钮 */

@end

@implementation SCDetailFirstCell

- (void)awakeFromNib {

    self.authorImgView.layer.cornerRadius = 15;
    self.authorImgView.clipsToBounds = YES;
}

// 加载xib
+ (instancetype)loadFirstCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"SCDetailFirstCell" owner:nil options:nil][0];
}

// 实例化可重用的cell
+ (instancetype)loadNewCellWithTableView:(UITableView *)tableView
{
    SCDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [self loadFirstCell];
        [tableView registerNib:[UINib nibWithNibName:@"SCDetailFirstCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return cell;
}

#pragma mark 设置cell的内容
- (void)setDemoAuthor:(SCDetailDemoAuthor *)demoAuthor
{
    _demoAuthor = demoAuthor;

    [self.authorImgView sd_setImageWithURL:[NSURL URLWithString:demoAuthor.avatar] placeholderImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
    self.authorName.text = demoAuthor.nickname;
    self.authorDesc.text = demoAuthor.desc;
}

@end
