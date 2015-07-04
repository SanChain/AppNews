

#import <Foundation/Foundation.h>


#define SCColour(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define SCScreenFrame [UIScreen mainScreen].bounds
#define SCScreenWith [UIScreen mainScreen].bounds.size.width
#define SCScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCNavigationBarH 44
#define SCImageCount 3

// 我的 模块
#define SCSreenW [UIScreen mainScreen].bounds.size.width
#define SCIntroViewH [UIScreen mainScreen].bounds.size.height * 0.35
#define SCOptionH [UIScreen mainScreen].bounds.size.height * 0.08
#define SCNaviBar 64

// 详情里的cell编号
#define SCDetailFirstCellNumber 0
#define SCDetailSecondCellNumber 1
#define SCDetailThirdCellNumber 2

// 设置
#define SCSettingTitleFont [UIFont systemFontOfSize:15]
#define SCSettingDetailFont [UIFont systemFontOfSize:14]
#define SCSettingItemMargin 15
#define SCSettingItemRightMargin 40
#define SCSettingIconWH 50
#define SCSettingCellMargin 18