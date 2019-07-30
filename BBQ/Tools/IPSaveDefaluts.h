//
//  IPSaveDefaluts.h
//  BQInstallmentPurchase
//
//  Created by BQJR on 16/6/28.
//  Copyright © 2016年 BQJR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPSaveDefaluts : NSObject

/**
 *  保存值到UserDefaults
 *
 *  @param obj 值
 *  @param key key
 */
+ (void)setObject:(id)obj forKey:(NSString *)key;
/**
 *  从偏好设置中取出值
 */
+ (id)objectForKey:(NSString *)key;

+ (void)setBool:(BOOL)Bool forKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;

//  清除偏好设置
+ (void)emptyUserDefault;
+ (void)verifyErrorEmptyUserDefault;
/**
 *  移除key
 */
+ (void)removeObjectForKey:(NSString *)key;

@end
