//
//  UITableViewController+Login.m
//  Eagle
//
//  Created by Kishon Daniels on 1/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Login.h"


@implementation Login

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];

    _email.delegate = self;
    _password.delegate = self;
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    [_email becomeFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
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
    return 2;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    
    if ([_email.text isEqualToString:@""] || [_password.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whooops" message:@"The email or password you entered is incorrect" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"Login" sender:self];
        
        return;
    }
    
    else {
    
    [PFUser logInWithUsernameInBackground:_email.text password:_password.text block:^(PFUser *user, NSError *error) {
        if (error) {
            
             NSLog(@"Error while logging in");
            
            return;
            
            
        }
        else if (!error) {
            
            NSLog(@"Login user");
            
            _email.text = _email.text;
            
            _password.text = _password.text;
            
            return;
            
        }
        
    }];
    }
    
}

- (IBAction)cancel:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
