//
//  AppDelegate.m
//  BBQ
//
//  Created by sherwin.chen on 2019/3/20.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "SHLocalNotice.h"
#import "JKUserDefaultKeys.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:1.5];

    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self; // 检查这个代理是否设置
    }

    [SHCF registerAPN:^(BOOL granted) {

        [self setLocalNotificaTimes];
        //[SHCF sendLocalNotification4Sec:30];

    }];

    return YES;
}

-(void) setLocalNotificaTimes {
    
    NSNumber *bTime20_30 = JKUserDefaultGetObjct(kTime20_30);
    if ([bTime20_30 boolValue]) {
        NSLog(@"已设置，不需要再提醒了.");
        return;
    }
    else {
        [SHCF sendLocalNotification4Hour:20 minute:31];
        JKUserDefaultSetBool(YES, kTime20_30);
    }

    NSNumber *bTime19_00 = JKUserDefaultGetObjct(kTime19_00);
    if ([bTime19_00 boolValue]) {
        NSLog(@"已设置，不需要再提醒了.");
        return;
    }
    else {
        [SHCF sendLocalNotification4Hour:19 minute:2];
        JKUserDefaultSetBool(YES, kTime19_00);
    }

    return;
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

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

}

@end
