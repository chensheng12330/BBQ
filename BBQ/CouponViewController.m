//
//  CouponViewController.m
//  BBQ
//
//  Created by sherwin.chen on 2019/3/31.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

/*
 section 0: 我的优惠券
 section 1: 可兑换优惠券
 */

#import "CouponViewController.h"
#import "CouponTableViewCell.h"
#import "CouponTableHeadViewCell.h"


#define K_couponId @"couponId"
#define K_couponMoney @"couponMoney"
#define K_effectiveEndTime @"effectiveEndTime"
#define K_effectiveStartTime @"effectiveStartTime"



@interface CouponViewController ()
@property (nonatomic, strong) CouponTableHeadViewCell* mHeadView;

@property (nonatomic, strong) NSArray *arMyCouponList;
@property (nonatomic, strong) NSArray *arConvCouponList;
@property (nonatomic, strong) NSDictionary *selectConvCoupon;

//
@property(nonatomic, assign) NSURLRequestCachePolicy mCachePolicy;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.mCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    self.title = @"我的优惠券";

    [self.tableView registerNib:[UINib nibWithNibName:@"CouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangeCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChangeCouponTableViewCell"];
    
    self.mHeadView = [[NSBundle mainBundle] loadNibNamed:@"CouponTableHeadView" owner:nil options:nil].firstObject;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    [refreshControl beginRefreshing];
    [self refresh];

    //self.view.
    
    return;
}


-(void) refresh {
    [self net4WalletInfo];
    
    [self net4MMTCouponInfo];
    
    [self net4CanUseCouponList];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num=0;
    if (section==0) {
        num = self.arMyCouponList.count;
    }
    else if (section==1) {
        num = self.arConvCouponList.count;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height;
    if (indexPath.section == 0) {
        height = 80;
    }
    else {
        height = 70;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 80;
    }
    return 40;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return self.mHeadView;
    }
    else {
        UILabel *lab1 = [[UILabel alloc] init];
        lab1.backgroundColor = [UIColor colorWithRed:253/255.0 green:242/255.0 blue:238/255.0 alpha:1];
        lab1.font =  [UIFont systemFontOfSize:14];
        lab1.text = @"    😋买买乐购可兑换券😋";
        return lab1;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *retCell =nil;
    
    if (indexPath.section ==0) {
        static NSString *cellIdentifier = @"CouponTableViewCell";
        
        CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[CouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        ///
        
        NSDictionary *info = self.arMyCouponList[indexPath.row];
        //
        NSString *strTime = info[K_effectiveEndTime];
        strTime = [strTime componentsSeparatedByString:@" "].firstObject;

        cell.lbEffectiveTime.text = [NSString stringWithFormat:@"有效期至-%@",strTime];
        cell.lbCouponMoney.text = [NSString stringWithFormat:@"￥%@",info[K_couponMoney]];
        
        retCell = cell;
    }
    else if (indexPath.section ==1) {
        static NSString *cellIdentifier = @"ChangeCouponTableViewCell";
        
        CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[CouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSDictionary *info = self.arConvCouponList[indexPath.row];
        
        cell.lbCouponMoney.text = [NSString stringWithFormat:@"￥%@",info[K_couponMoney]];
        retCell = cell;
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    //retCell.spa
    return retCell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        //跳买买乐购
    }
    else if(indexPath.section == 1){
        //开启兑换
        NSDictionary *info = self.arConvCouponList[indexPath.row];
        self.selectConvCoupon = info;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"兑换优惠券" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击确认");
            
            [self net4ConvertCoupon];
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 网络请求
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


//! 钱包信息.
-(void) net4WalletInfo {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://rst.bqjr.cn/rst-business/bqjrMiniPortal/initMinePage/%@",self.userId]]
                                                           cachePolicy:self.mCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error) {
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
            
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
            
            NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.refreshControl endRefreshing];
                
                if([respDict[@"code"] integerValue] == 200){
                    NSDictionary *data = respDict[@"data"];
                    float availableIntegral = [data[@"availableIntegral"]  floatValue];
                    float todayIntegral = [data[@"todayIntegral"] floatValue];
                    float totalIntegral = [data[@"totalIntegral"] floatValue];
                    
                    [self.mHeadView setAvailableIntegral:availableIntegral
                                           todayIntegral:todayIntegral
                                           totalIntegral:totalIntegral];
                    
                }
                else {
                    
                    
                }
                
            });
            
            
        }
                                                 
    }];
    [dataTask resume];
    
}


/*
 
 {
 "code": 200,
 "data": [
 {
 "couponId": "yeyaofulihuodong4",
 "couponMoney": 5,
 "couponName": "夜摇福利活动",
 "couponNo": "1903189762670120",
 "effectiveEndTime": "2019-06-15 23:59:59",
 "effectiveStartTime": "2019-03-18 10:35:26",
 "status": 1
 }
 ]
 }
 
 */

-(void) net4MMTCouponInfo {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://rst.bqjr.cn/rst-business/bqjrMiniPortal/MMTCouponInfo/%@",self.userId] ]
                                                           cachePolicy:self.mCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error) {
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
            
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"%@", httpResponse);
            
            NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.refreshControl endRefreshing];
                
                if([respDict[@"code"] integerValue] == 200){
  
                    self.arMyCouponList = respDict[@"data"];
                    //[self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.tableView reloadData];
                    
                }
                else {
                    
                    
                }
                
            });
            
            
        }
    }];
    [dataTask resume];
}

-(void)net4CanUseCouponList {

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.bqjr.cn/rst-business/bqjrMiniPortal/MMTCouponList"]
                                                           cachePolicy:self.mCachePolicy
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
                                                        
                                                        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            [self.refreshControl endRefreshing];
                                                            
                                                            if([respDict[@"code"] integerValue] == 200){
                                                                
                                                                self.arConvCouponList = respDict[@"data"];
                                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                                                                
                                                            }
                                                            else {
                                                                
                                                                
                                                            }
                                                            
                                                        });
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
    //NSNumber *couponMoney = ;
    //@"https://rst.bqjr.cn/rst-business/integral/convert/U025299276927500?amount=200&couponCode=yeyaofulihuodong6"
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://rst.bqjr.cn/rst-business/integral/convert/%@?amount=%ld&couponCode=%@",self.userId,[self.selectConvCoupon[@"couponMoney"] integerValue], self.selectConvCoupon[@"couponId"]] ]
                                                           cachePolicy:self.mCachePolicy
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
                                                        
                                                        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            if([respDict[@"code"] integerValue] == 200){
                                                                
                                                                [self showAlert:@"恭喜胸de，兑换成功."];
                                                                
                                                                [self refresh];
                                                            }
                                                            else {
                                                                
                                                                [self showAlert:respDict[@"remark"]];
                                                            }
                                                            
                                                        });
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

-(void) showAlert:(NSString*) info {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:info preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
