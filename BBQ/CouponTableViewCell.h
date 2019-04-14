//
//  CouponTableViewCell.h
//  BBQ
//
//  Created by sherwin.chen on 2019/3/31.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

/*
 "couponMoney": 200,
 "couponName": "夜摇福利活动",
 "couponNo": "1903317857308320",
 "effectiveEndTime": "2019-06-28 23:59:59",
 "effectiveStartTime": "2019-03-31 21:43:46",
 "status": 1
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponTableViewCell : UITableViewCell

//可兑换现金券
@property (nonatomic, weak) IBOutlet UILabel *lbCouponMoney;

@end

NS_ASSUME_NONNULL_END
