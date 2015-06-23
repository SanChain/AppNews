

#import "UIWindow+Extension.h"
#import "SCTabBarController.h"
#import "SCNewfeatureController.h"
#import "SCAccount.h"
#import "SCAccountTool.h"
#import "SCLoginViewController.h"

@implementation UIWindow (Extension)

// 选择 根视图控制器
- (void)switchRootViewController{
    
    NSString *key = @"CFBundleVersion";
    // 上一次使用的版本（存储在沙盒中的版本号）
    NSString *version = [[NSUserDefaults standardUserDefaults]valueForKey:key];
    // 当前软件的版本号（从info.plist中获得）
    NSDictionary *dict = [[NSBundle mainBundle]infoDictionary];
    NSString *currentVersion = dict[key];
    
    if ([currentVersion isEqualToString:version]) { // 版本号相同：这次打开和上次打开的是同一个版本
        SCAccount *account = [SCAccountTool account];
        if (account) { // 登陆过了
            self.rootViewController = [[SCTabBarController alloc] init];
        } else { // 没有登陆过
            self.rootViewController = [[SCLoginViewController alloc]init];
        }
        
    } else { // 这次打开的版本和上一次不一样，显示新特性
        self.rootViewController = [[SCNewfeatureController alloc]init];
        // 把当前版本号存进沙盒里
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize]; // 这句代码过后，会马上把版本号存储到沙盒里
    }
}

@end
