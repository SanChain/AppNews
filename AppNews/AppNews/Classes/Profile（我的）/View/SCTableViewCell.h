//
//  SCTableViewCell.h
//  AppNews
//
//  Created by SanChain on 15/6/21.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCProfileLikes;

@interface SCTableViewCell : UITableViewCell
+ (id)newCell;


@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *inputTime;
@property (weak, nonatomic) IBOutlet UILabel *intro;

@property (weak, nonatomic) IBOutlet UILabel *founder;
@property (weak, nonatomic) IBOutlet UIButton *likes;
@property (nonatomic, strong) SCProfileLikes *profileLikes;
@end
