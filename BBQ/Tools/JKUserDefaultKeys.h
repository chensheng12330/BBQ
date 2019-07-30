//
//  JKUserDefaultKeys.h
//  Wallet
//
//  Created by shif.jhon on 2018/11/27.
//  Copyright © 2018年 深圳市买买提信息科技有限公司. All rights reserved.
//

#ifndef JKUserDefaultKeys_h
#define JKUserDefaultKeys_h

//  fast creat
#define kUserDefault [NSUserDefaults standardUserDefaults]

#import "IPSaveDefaluts.h"

//  keys 值不可改 否则版本更新后会找不到该key对应的值

#define kTimeNotiSet  (@"kTimeNotiSet")    //是否已设置.

#define kTime20_30  (@"kTime20_30")    //晚上8点半
#define kTime19_00  (@"kTime19_00")     //晚上7点


//  obj
#define JKUserDefaultSetObjct(obj ,key) [IPSaveDefaluts setObject:obj forKey:key]
#define JKUserDefaultGetObjct(key) [IPSaveDefaluts objectForKey:key]

//  bool
#define JKUserDefaultSetBool(bool, key) [IPSaveDefaluts setBool:bool forKey:key]
#define JKUserDefaultGetBool(key) [IPSaveDefaluts boolForKey:key]

//  remove
#define JKUserDefaultRemoveObject(key) [IPSaveDefaluts removeObjectForKey:key]

#endif /* JKUserDefaultKeys_h */
