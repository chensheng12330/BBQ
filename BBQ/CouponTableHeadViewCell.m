//
//  CouponTableHeadViewCell.m
//  BBQ
//
//  Created by sherwin.chen on 2019/4/14.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

#import "CouponTableHeadViewCell.h"

@implementation CouponTableHeadViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setAvailableIntegral:(float)availableIntegral
               todayIntegral:(float)todayIntegral
               totalIntegral:(float)totalIntegral {

    self.lbTodayIntegral.text = [NSString stringWithFormat:@" $%.2f",todayIntegral];
    self.lbAvailableIntegral.text = [NSString stringWithFormat:@"$%.2f",availableIntegral];
    self.lbTotalIntegral.text = [NSString stringWithFormat:@"$%.2f",totalIntegral];
    return;
}

@end
