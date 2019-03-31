//
//  CouponViewController.m
//  BBQ
//
//  Created by sherwin.chen on 2019/3/31.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponTableViewCell.h"

@interface CouponViewController ()

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的优惠券";

    [self.tableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponTableViewCell"];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    //[refreshControl beginRefreshing];
    
    return;
}

-(void) refresh {
    [self net4MMTCouponInfo];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CouponTableViewCell";
    
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(NSString*) tokenKey{
    return [NSString stringWithFormat:@"token=%@",self.token];
}

- (NSDictionary*) getHeadDict {
    
    NSDictionary *headers = @{ @"Content-Type": @"application/json",
                               @"rstTenantCode": @"5000",
                               @"Accept": @"*/*",
                               @"Connection": @"keep-alive",
                               @"Cookie":  [self tokenKey],
                               @"rstWxAppId": @"wx067bb2c9b50e62bc",
                               @"User-Agent": @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15G77 MicroMessenger/7.0.3(0x17000321) NetType/WIFI Language/zh_CN",
                               @"Referer": @"https://servicewechat.com/wx067bb2c9b50e62bc/7/page-frame.html",
                               @"Accept-Language": @"zh-cn",
                               @"Accept-Encoding": @"br, gzip, deflate",
                               @"cache-control": @"no-cache"  };
    return headers;
}

-(void) net4MMTCouponInfo {

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.jianli.tech/rst-business/bqjrMiniPortal/MMTCouponInfo/U025299276927500"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.refreshControl endRefreshing];
                                                        });
                                                        
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.refreshControl endRefreshing];
                                                        });
                                                        
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

-(void)net4CanUseCouponList {

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.jianli.tech/rst-business/bqjrMiniPortal/MMTCouponList"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}

/*
 {
 "code": 200,
 "data": {
 "todayIntegral": 0,
 "availableIntegral": 84,
 "userCouponList": [
 {
 "couponId": "yeyaofulihuodong6",
 "couponMoney": 200,
 "couponName": "夜摇福利活动",
 "couponNo": "1903317857308320",
 "effectiveEndTime": "2019-06-28 23:59:59",
 "effectiveStartTime": "2019-03-31 21:43:46",
 "status": 1
 },
 {
 "couponId": "yeyaofulihuodong4",
 "couponMoney": 5,
 "couponName": "夜摇福利活动",
 "couponNo": "1903189762670120",
 "effectiveEndTime": "2019-06-15 23:59:59",
 "effectiveStartTime": "2019-03-18 10:35:26",
 "status": 1
 }
 ],
 "totalIntegral": 489
 }
 }
 */

-(void) net4ConvertCoupon {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.jianli.tech/rst-business/integral/convert/U025299276927500?amount=200&couponCode=yeyaofulihuodong6"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}
@end
