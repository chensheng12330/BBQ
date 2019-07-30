//
//  SHLocalNotice.h
//  BBQ
//
//  Created by sherwin.chen on 2019/7/29.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SHCF [SHLocalNotice sharedSingle]

@interface SHLocalNotice : NSObject

+ (instancetype)sharedSingle;

- (void)registerAPN:(void (^)(BOOL granted))completionHandler;

- (void)sendLocalNotification4Hour:(NSInteger)hour
                            minute:(NSInteger)minute;

- (void)cancelLocalNotificaitons;

- (void)sendLocalNotification4Sec:(NSInteger) timeInteval;

@end

NS_ASSUME_NONNULL_END

