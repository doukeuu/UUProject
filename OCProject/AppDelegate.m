//
//  AppDelegate.m
//  OCProject
//
//  Created by Pan on 2020/5/11.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController: [[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLogoutResponse:) name:UUNetworkResponseStatusCode401 object:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Respond

// 收到退出登陆通知
- (void)receiveLogoutResponse:(NSNotification *)notice {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (![controller isKindOfClass:[UITabBarController class]]) return;
    if ([controller.presentedViewController isKindOfClass:[UIAlertController class]]) return;
    
    NSString *tips = notice.userInfo[UUNetworkErrorTips];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:tips preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确  定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [LOGIN clearInfo];
        [self changeWindowRootViewController];
    }]];
    [controller presentViewController:alert animated:YES completion:nil];
}

// 改变window的rootViewController
- (void)changeWindowRootViewController {
    // 已登陆
//    if ([LOGIN extractInfo]) {
//        self.window.rootViewController = [[UUTabBarController alloc] init];
//        return;
//    }
    // 未登陆
//    UIViewController *controller = [[UULoginPageController alloc] init];
//    self.window.rootViewController = [[YMNavigationController alloc] initWithRootViewController:controller];
}

@end
