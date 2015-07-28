//
//  UITableViewController+SignUp.m
//  Eagle
//
//  Created by Kishon Daniels on 1/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "SignUp.h"

@implementation SignUp
@synthesize username;
@synthesize email;
@synthesize password;
@synthesize confirm;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
     self.tableView.tableFooterView = [UIView new];
    
    username.delegate = self;
    email.delegate = self;
    password.delegate = self;
    confirm.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [username becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 4;
}

- (IBAction)registerButton:(id)sender {
    PFUser *user = [PFUser user];
    user.username = username.text;
    user.email = email.text;
    user.password = password.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success");
        }
        else {
            NSLog(@"Error");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
