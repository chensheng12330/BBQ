//
//  CouponTableHeadViewCell.h
//  BBQ
//
//  Created by sherwin.chen on 2019/4/14.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//
/*
 str = [str stringByReplacingOccurrencesOfString:@"availableIntegral" withString:@"可兑换零钱"];
 
 str = [str stringByReplacingOccurrencesOfString:@"todayIntegral" withString:@"今日获取"];
 
 str = [str stringByReplacingOccurrencesOfString:@"totalIntegral" withString:@"历史总额"];
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponTableHeadViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lbAvailableIntegral;
@property (nonatomic, weak) IBOutlet UILabel *lbTodayIntegral;
@property (nonatomic, weak) IBOutlet UILabel *lbTotalIntegral;

-(void) setAvailableIntegral:(float)availableIntegral
               todayIntegral:(float)todayIntegral
               totalIntegral:(float)totalIntegral;
@end

NS_ASSUME_NONNULL_END
