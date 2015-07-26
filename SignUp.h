//
//  UITableViewController+SignUp.h
//  Eagle
//
//  Created by Kishon Daniels on 6/11/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ProgressHUD.h"

@interface SignUp : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *confirm;
@property (nonatomic, strong) IBOutlet UITextField *username;

-(IBAction)registerButton:(id)sender;
-(IBAction)cancel:(id)sender;

@end
