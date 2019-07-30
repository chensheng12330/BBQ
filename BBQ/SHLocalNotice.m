//
//  SHLocalNotice.m
//  BBQ
//
//  Created by sherwin.chen on 2019/7/29.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLocalNotice.h"
#import <UserNotifications/UserNotifications.h>
#import "JKUserDefaultKeys.h"


@implementation SHLocalNotice

static NSString * LocalNotiReqIdentifer=@"LocalNotiReqIdentifer";

static SHLocalNotice *_singleLocalNotice = nil;
+ (instancetype)sharedSingle {
    if (!_singleLocalNotice) {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{

            _singleLocalNotice = [[SHLocalNotice alloc] init];
        });
    }
    return _singleLocalNotice;
}



// 注册通知
- (void)registerAPN:(void (^)(BOOL granted))completionHandler {

    if (@available(iOS 10.0, *)) { // iOS10 以上
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {

            completionHandler(granted);

        }];
    } else {// iOS8.0 以上
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];

        completionHandler(YES);
    }
}



//[self sendLocalNotification];

/*
 
 */

- (void)sendLocalNotification4Hour:(NSInteger)hour
                            minute:(NSInteger)minute {

    NSString *title = @"BBQ";
    NSString *sutitle = @"点我，点我，点我";
    NSString *body = @"小老弟,快来领钱了.";
    NSInteger badge = 1;
    //NSInteger timeInteval = 60;
    NSDictionary *userInfo = @{@"id":@"LOCAL_NOTIFY_SCHEDULE_ID"};

    if (@available(iOS 10.0, *)) {
        // 1.创建通知内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        //[content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
        content.sound = [UNNotificationSound defaultSound];
        content.title = title;
        content.subtitle = sutitle;
        content.body = body;
        content.badge = @(badge);

        content.userInfo = userInfo;

        // 2.设置通知附件内容
        /*
         NSError *error = nil;
         NSString *path = [[NSBundle mainBundle] pathForResource:@"logo_img_02@2x" ofType:@"png"];
         UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
         if (error) {
         NSLog(@"attachment error %@", error);
         }
         content.attachments = @[att];
         //content.launchImageName = @"AppIcon";
         */

        // 2.设置声音
        UNNotificationSound *sound = [UNNotificationSound defaultSound]; //[UNNotificationSound soundNamed:@"sound01.wav"];
        content.sound = sound;


        //根据当前时间，计算下一次消息通知触发时间值。第二天晚上8:31触发


        // 3.触发模式
        /*
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:timeInteval
                                                      repeats:NO];
         */

        //如果想重复可以使用这个,按日期
        // 每天晚上 7点10 / 8点30
        //
        // 周一至周五

        for (int i=2; i<7; i++) {

            NSDateComponents *components = [[NSDateComponents alloc] init];
            // 注意，weekday默认是从周日开始 1周日， 2周一
            components.weekday = i;
            components.hour    = hour;
            components.minute  = minute;

            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];

            // 4.设置UNNotificationRequest
            NSString *idf = [NSString stringWithFormat:@"%@%ld%ld%d",LocalNotiReqIdentifer,(long)hour,(long)minute,i];

            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:idf content:content trigger:trigger];

            // 5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                NSLog(@"UNUserNotificationCenter:  %@",error);

            }];

        }

    } else {

        UILocalNotification *localNotification = [[UILocalNotification alloc] init];

        // 1.设置触发时间（如果要立即触发，无需设置）
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];

        // 2.设置通知标题
        localNotification.alertBody = title;

        // 3.设置通知动作按钮的标题
        localNotification.alertAction = @"查看";

        // 4.设置提醒的声音
        localNotification.soundName = @"sound01.wav";// UILocalNotificationDefaultSoundName;

        // 5.设置通知的 传递的userInfo
        localNotification.userInfo = userInfo;

        // 6.在规定的日期触发通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        // 6.立即触发一个通知
        //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}


- (void)cancelLocalNotificaitons {

    /*
    // 取消一个特定的通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    // 获取当前所有的本地通知
    if (!notificaitons || notificaitons.count <= 0) { return; }
    for (UILocalNotification *notify in notificaitons) {
        if ([[notify.userInfo objectForKey:@"id"] isEqualToString:LocalNotiReqIdentifer]) {
            if (@available(iOS 10.0, *)) {
                [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[LocalNotiReqIdentifer]];
            } else {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
            }
            break;
        }
    }
     */
    
    // 取消所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)sendLocalNotification4Sec:(NSInteger) timeInteval {

    NSString *title = @"BBQ";
    NSString *sutitle = @"点我，点我，点我";
    NSString *body = @"小老弟,快来领钱了.";
    NSInteger badge = 1;
    NSDictionary *userInfo = @{@"id":@"LOCAL_NOTIFY_SCHEDULE_ID"};

    // 1.创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //[content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
    content.sound = [UNNotificationSound defaultSound];
    content.title = title;
    content.subtitle = sutitle;
    content.body = body;
    content.badge = @(badge);
    content.userInfo = userInfo;

    // 2.设置通知附件内容
     NSError *error = nil;
     NSString *path = [[NSBundle mainBundle] pathForResource:@"mylog@2x" ofType:@"png"];
     UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
     if (error) {
     NSLog(@"attachment error %@", error);
     }
     content.attachments = @[att];
     //content.launchImageName = @"AppIcon";
     /**/

    // 2.设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound]; //[UNNotificationSound soundNamed:@"sound01.wav"];
    content.sound = sound;

    //根据当前时间，计算下一次消息通知触发时间值。第二天晚上8:31触发

    // 3.触发模式
     UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
     triggerWithTimeInterval:timeInteval
     repeats:NO];
     /**/

    // 4.设置UNNotificationRequest
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:LocalNotiReqIdentifer content:content trigger:trigger];

    // 5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"UNUserNotificationCenter:  %@   id:%@",error,request.identifier);

    }];

}

@end
