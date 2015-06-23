//
//  SCSpecialCell.h
//  AppNews
//
//  Created by SanChain on 15/6/20.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCSpecialItem;

@interface SCSpecialCell : UICollectionViewCell
/** specialItem模型 */
@property (nonatomic, strong) SCSpecialItem *specialItem;
/** item图片 */
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
/** item标题 */
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;

@end
