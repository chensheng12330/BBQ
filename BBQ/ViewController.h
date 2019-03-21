//
//  ViewController.h
//  BBQ
//
//  Created by sherwin.chen on 2019/3/20.
//  Copyright © 2019 sherwin.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfToken;
@property (weak, nonatomic) IBOutlet UITextField *tfUserID;
@property (weak, nonatomic) IBOutlet UITextView *tvLogView;

//更多
- (IBAction)MoreAction:(UIButton *)sender;
//
- (IBAction)upateAction:(UIButton *)sender;

- (IBAction)buttonAction:(UIButton *)sender;

- (IBAction)clearAction:(UIButton *)sender;

@end

