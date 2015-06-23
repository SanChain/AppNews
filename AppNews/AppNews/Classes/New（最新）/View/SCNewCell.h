//
//  SCNewCell.h
//  AppNews
//
//  Created by SanChain on 15/6/19.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNewDemoItem.h"

@interface SCNewCell : UITableViewCell
/** demoItem模型 */
@property (nonatomic, strong) SCNewDemoItem *demoItem;

@property (weak, nonatomic) IBOutlet UIButton *likes;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *founder;
@property (weak, nonatomic) IBOutlet UILabel *inputTime;
@property (weak, nonatomic) IBOutlet UILabel *intro;

+ (id)newsCell; // 创建一个cell
- (IBAction)clickLikesBtn:(UIButton *)btn;

@end
