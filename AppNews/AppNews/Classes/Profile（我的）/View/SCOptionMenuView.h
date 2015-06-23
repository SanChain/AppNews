//
//  SCOptionMenuView.h
//  AppNews
//
//  Created by SanChain on 15/6/21.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCOptionMenuView : UIView

/** 加载xib */
+ (id)loadOptionMenuView;
/** 监听点赞产品按钮 */
- (IBAction)clickLikesBtn:(UIButton *)sender;
/** 监听发布产品按钮 */
- (IBAction)clickPublishBtn:(id)sender;
/** 监听评论产品按钮 */
- (IBAction)clickCommentBtn:(id)sender;

/** label */
@property (weak, nonatomic) IBOutlet UILabel *likesL;
@property (weak, nonatomic) IBOutlet UILabel *publishL;
@property (weak, nonatomic) IBOutlet UILabel *commentL;

/** 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;

@end
