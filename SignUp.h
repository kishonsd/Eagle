//
//  UITableViewController+SignUp.h
//  Eagle
//
//  Created by Kishon Daniels on 1/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "KVNProgress.h"
#import "KVNProgressConfiguration.h"

@interface SignUp : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *confirm;
@property (nonatomic) KVNProgressConfiguration *customConfiguration;

-(IBAction)registerButton:(id)sender;
-(IBAction)cancel:(id)sender;

@end
