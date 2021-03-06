//
//  ViewController.m
//  BBQ
//
//  Created by sherwin.chen on 2019/3/20.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "CouponViewController.h"

#define K_token @"token"
#define K_userid @"userid"

#define K_GetToken  [self tokenKey]

@interface ViewController ()<UITextFieldDelegate>

@property(nonatomic, copy) NSString* mToken;
@property(nonatomic, copy) NSString* mUserId;

@property(nonatomic, strong) NSMutableString* mLog;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //初使化数据
    
    
    [self setEditing:YES];
    
    self.mLog = [[NSMutableString alloc] init];
    
    self.mToken = [[NSUserDefaults standardUserDefaults] objectForKey:K_token];
    self.mUserId = [[NSUserDefaults standardUserDefaults] objectForKey:K_userid];
    
    //self.mToken = @"AAABbDje8msAAAAQVTAyNTI5OTI3NjkyNzUwMA";
    //self.mUserId = @"U025299276927500";
    
    [self.tfToken setText:self.mToken];
    [self.tfUserID setText:self.mUserId];
    
    self.tfToken.delegate = self;
    self.tfUserID.delegate = self;
    
    [self log:[NSString stringWithFormat:@"本地，token:%@  userid: %@",self.mToken,self.mUserId]];
    
    self.tvLogView.editable = NO;
    self.tvLogView.layoutManager.allowsNonContiguousLayout = NO;
    
    [self setNaveBarUI];

    [self timeProcess];

    return;
}

-(void) setNaveBarUI {
    self.title = @"BBQ";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:1 green:147/255.0 blue:0 alpha:1];
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, 80, 40);
    [btn setTitle:@"更多☀️" forState:0]; //
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [btn addTarget:self action:@selector(MoreAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //self.navigationController.
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    return;
}

-(NSString*) tokenKey{
    return [NSString stringWithFormat:@"token=%@",self.mToken];
}

-(void) log:(NSString*)str {
    if (str.length<1) {
        return;
    }
    
    [self.mLog appendFormat:@"🍀%@, %@ \r\n",[NSDate date],str];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tvLogView setText:self.mLog];
        [self.tvLogView scrollRangeToVisible:NSMakeRange(self.tvLogView.text.length, 1)];
    });
    
    return;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.tfToken) {
        self.mToken = textField.text;
    }
    else {
        self.mUserId = textField.text;
        [self upateAction:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.tfToken) {
        
        [self.tfUserID becomeFirstResponder];
        
    }
    else{
        [self.tfUserID resignFirstResponder];
    }
  
    return YES;
}

#pragma mark - --内部函数

//读取本地配置定时任务信息
-(void)  timeProcess {

    // 今天的基准时间.
    NSDate *currentDate = [NSDate date];//当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];//当前用户的calendar
    NSDateComponents * components = [calendar components:
                                     NSCalendarUnitSecond   | NSCalendarUnitMinute | NSCalendarUnitHour |  NSCalendarUnitDay   | kCFCalendarUnitWeekday
                                                fromDate:currentDate];
    //排除掉今天是周未
    // 周日 1  周一 2
    if (components.weekday == 1 || components.weekday == 7) {
        return;
    }

    //19:00
    if(  components.hour == 19 && components.minute<30){
        [self net4BBQ];
        [self net4WalletInfo];
    }

    //20:30   || components.hour>20
    if(  components.hour == 20 && components.minute<50){
        [self net4SetLocation];
        [self net4BBNum];
        return;
    }
    return;
}

#pragma mark - --事件
- (void)MoreAction:(UIButton *)sender {

    if (self.mUserId.length<1 || self.mToken.length<1) {
        [self showAlert:@"404, 配好token再跟进."];
        return;
    }

    CouponViewController *vc =[[CouponViewController alloc] init];
    vc.userId = self.mUserId;
    vc.token  = self.mToken;
    
    [self.navigationController pushViewController:vc animated:YES];
    return;
}

-(void) showAlert:(NSString*) info {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:info preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        NSLog(@"点击取消");

    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)upateAction:(UIButton *)sender {
    
    [self.tfUserID resignFirstResponder];
    [self.tfToken resignFirstResponder];
    
    if (self.mUserId.length<1 || self.mToken.length <1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"大佬，userid/token填的空的好吗？" delegate:nil cancelButtonTitle:@"啰嗦" otherButtonTitles: @"就不",nil];
        [alert show];
        return;
    }
    
    //更新当前保存的数据.
    [self.tfUserID resignFirstResponder];
    [self.tfToken resignFirstResponder];
    
    self.mToken = self.tfToken.text;
    self.mUserId= self.tfUserID.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.mToken forKey:K_token];
    [[NSUserDefaults standardUserDefaults] setObject:self.mUserId forKey:K_userid];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self log:@"数据更新成功."];
    return;
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.mUserId.length<1 || self.mToken.length <1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"胸得，请先配置好userid/token." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }

    [self log:@"😋😛😝😜🤪服务请求中,请稍等..."];
    NSInteger tag = sender.tag;
    if(tag == 1){
        [self net4CurrentTime];
        
        [self net4NullReq1];
        
        [self net4NullReq2];
        
        [self net4SetLocation];
    }
    else if(tag == 2){
        [self net4BBNum];
    }
    else if(tag == 3){
        [self net4BBQ];
    }
    else if(tag == 4){
        [self net4WalletInfo];
    }
    return;
}

- (IBAction)clearAction:(UIButton *)sender {

    [self.mLog setString:@""];
    [self log:@"已刷新."];
}

#pragma mark - --网络
- (NSDictionary*) getHeadDict {

    NSDictionary *headers = @{ @"Content-Type": @"application/json",
                               @"rstTenantCode": @"5000",
                               @"Accept": @"*/*",
                               @"Connection": @"keep-alive",
                               @"Cookie":  K_GetToken,
                               @"rstWxAppId": @"wx067bb2c9b50e62bc",
                               @"User-Agent": @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15G77 MicroMessenger/7.0.3(0x17000321) NetType/WIFI Language/zh_CN",
                               @"Referer": @"https://servicewechat.com/wx067bb2c9b50e62bc/7/page-frame.html",
                               @"Accept-Language": @"zh-cn",
                               @"Accept-Encoding": @"br, gzip, deflate",
                               @"cache-control": @"no-cache"  };
    return headers;
}

//! 获取服务器时间
-(void) net4CurrentTime {


    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.bqjr.cn/rst-activity/system/currentTime"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        //[self log:[NSString stringWithFormat:@"%@", error]];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSString *str = [[NSString  alloc] initWithData:data encoding:4];
                                                        [self log:[NSString stringWithFormat:@"%@", str]];
                                                    }
                                                }];
    [dataTask resume];
}

//! 空操作
-(void) net4NullReq1 {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.bqjr.cn/rst-business/activityInfo/listOfOpened"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                       // [self log:[NSString stringWithFormat:@"%@", error]];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                       // [self log:[NSString stringWithFormat:@"%@", httpResponse]];
                                                    }
                                                }];
    [dataTask resume];
}

//! 空操作
-(void) net4NullReq2 {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.bqjr.cn/rst-activity/activityInfo/list"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        //[self log:[NSString stringWithFormat:@"%@", error]];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        //[self log:[NSString stringWithFormat:@"%@", httpResponse]];
                                                    }
                                                }];
    [dataTask resume];
}
//! 上传地理位置
-(void) net4SetLocation {


    NSDictionary *parameters = @{ @"accuracy": @65,
                                  @"horizontalAccuracy": @65,
                                  @"latitude": @22.564407348632812,
                                  @"longitude": @114.06963348388672,
                                  @"speed": @-1,
                                  @"userId": self.mUserId,
                                  @"verticalAccuracy": @10 };
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rst.bqjr.cn/rst-business/location"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [self log:[NSString stringWithFormat:@"%@", error]];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSString *str = [[NSString  alloc] initWithData:data encoding:4];
                                                        [self log:[NSString stringWithFormat:@"%@", str]];
                                                        //[self log:[NSString stringWithFormat:@"%@", httpResponse]];
                                                    }
                                                }];
    [dataTask resume];
}

//! 获取可抽次数
-(void) net4BBNum {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://rst.bqjr.cn/rst-business/lottery/num/%@",self.mUserId]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [self log:[NSString stringWithFormat:@"%@", error]];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSString *str = [[NSString  alloc] initWithData:data encoding:4];


                                                        str = [str stringByReplacingOccurrencesOfString:@"data" withString:@"今日抽奖次数"];

                                                        [self log:[NSString stringWithFormat:@"%@", str]];
                                                    }
                                                }];
    [dataTask resume];
}
//! 抽奖
-(void) net4BBQ {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://rst.bqjr.cn/rst-business/lottery/draw/%@",self.mUserId]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [self log:[NSString stringWithFormat:@"%@", error]];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSString *str = [[NSString  alloc] initWithData:data encoding:4];
                                                        [self log:[NSString stringWithFormat:@"%@", str]];
                                                    }
                                                }];
    [dataTask resume];
}

//! 钱包信息.
-(void) net4WalletInfo {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://rst.bqjr.cn/rst-business/bqjrMiniPortal/initMinePage/%@",self.mUserId]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:[self getHeadDict]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        [self log:[NSString stringWithFormat:@"%@", error]];
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        //[self log:[NSString stringWithFormat:@"%@", httpResponse]];
                                                        
                                                        NSString *str = [[NSString  alloc] initWithData:data encoding:4];

                                                        str = [str stringByReplacingOccurrencesOfString:@"availableIntegral" withString:@"可兑换零钱"];

                                                        str = [str stringByReplacingOccurrencesOfString:@"todayIntegral" withString:@"今日获取"];

                                                        str = [str stringByReplacingOccurrencesOfString:@"totalIntegral" withString:@"历史总额"];

                                                        [self log:[NSString stringWithFormat:@"%@", str]];
                                                    }
                                                }];
    [dataTask resume];

}


@end
