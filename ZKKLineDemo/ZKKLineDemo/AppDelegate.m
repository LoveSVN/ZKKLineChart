//
//  AppDelegate.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/7.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKRootViewController.h"
#import "GApiConfig.h"
#import "AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)apiConfig {
    GApiConfig *_config = [GApiConfig sharedInstance];
    _config.baseUrl = @"http://www.ftamt.com";
    //根据需求设置
    _config.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/csv", nil];
    
    // 缓存时间
    _config.cacheTimeInterval = -1;
    
    // 请求超时时间
    _config.requestTimeoutInterval = 15.0f;
    
    // HTTP报头
    [_config setApiRequestHeaderFieldValueDictionary:@{@"Content-Type":@"application/x-www-form-urlencoded", @"Accept-Language":@"en-US;q=1"}];
}

- (void)networkMonitor {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"unknown networking");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"no network");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"wwan");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"wifi");
                break;
            }
        }
    }];
    [manager startMonitoring];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupWindow];
    
    // 网络配置
    [self apiConfig];
    
    //网络监听
    [self networkMonitor];
    
    return YES;
}

- (void)setupWindow {
    ZKRootViewController *rootVC = [ZKRootViewController new];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
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

@end
