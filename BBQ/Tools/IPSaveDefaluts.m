//
//  IPSaveDefaluts.m
//  BQInstallmentPurchase
//
//  Created by BQJR on 16/6/28.
//  Copyright © 2016年 BQJR. All rights reserved.
//

#import "IPSaveDefaluts.h"

@implementation IPSaveDefaluts

+ (void)emptyUserDefault {

}

//  验证错误退出登录
+ (void)verifyErrorEmptyUserDefault {
    
}


+ (void)setObject:(id)obj forKey:(NSString *)key {
    [self verifyKeyWithKey:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
        
}

+ (id)objectForKey:(NSString *)key {
    [self verifyKeyWithKey:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:key];
}

+ (void)setBool:(BOOL)Bool forKey:(NSString *)key {
    [self verifyKeyWithKey:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:Bool forKey:key];
    [defaults synchronize];
}

+ (BOOL)boolForKey:(NSString *)key {
    [self verifyKeyWithKey:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults boolForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key {
    [self verifyKeyWithKey:key];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void)verifyKeyWithKey:(NSString *)key {
    NSAssert(key, @"UserDefault key can't be nil");
}

@end
