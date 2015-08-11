//
//  UITableViewController+Login.m
//  Eagle
//
//  Created by Kishon Daniels on 1/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Login.h"
#import "KVNProgress.h"


@implementation Login

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];

    _username.delegate = self;
    _password.delegate = self;
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    [_username becomeFirstResponder];
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
    return 3;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.username) {
        [self.username becomeFirstResponder];
    }
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    }
    if (textField == self.password) {
        
        [self.password resignFirstResponder];
        [self processFieldEntries];
    }
    
    
    return YES;
}

- (void)processFieldEntries {
    
    //Get information and store it in the app delegate for now
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    NSString *errorText = @"Please ";
    NSString *noUsername = @"enter a username";
    NSString *errorTextJoin = @", and ";
    NSString *noPassword = @" enter a password";
    NSString *passwordsDontMatch = @"enter the same password twice";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
    
        if (password.length == 0) {
            [self.password becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.username becomeFirstResponder];
        }
        
        if (username.length == 0) {
            errorText = [errorText stringByAppendingString:noUsername];
        }
        
        if (password.length == 0) {
            if (username.length == 0) {
                
                // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:errorTextJoin];
                
            }
            
            errorText = [errorText stringByAppendingString:noPassword];
        }
        
    }
    
    else if ([password compare:password] != NSOrderedSame) {
        
        // We have non-zero strings.
        // Check for equal password strings.
        
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordsDontMatch];
        [self.password becomeFirstResponder];
        
    }
    
    if (textError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    [self.view endEditing:YES];
    
    
    [KVNProgress showProgress:0.0f status:@"Signing you up"];
    
    dispatch_main_after(3.0f, ^{
        [KVNProgress dismiss];
    });
    
    
    // Call into an object somewhere that has code for setting up a user.
    // The app delegate cares about this, but so do a lot of other objects.
    // For now, do this inline.
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            
            
            [KVNProgress showErrorWithStatus:@"Whoops, couldn't sign you up!"];
            
            [self.username becomeFirstResponder];
            
            
            
        }
        else if (!error) {
            
            [KVNProgress showSuccessWithStatus:@""];
            [self performSegueWithIdentifier:@"register" sender:self];
            
            
        }
        
    }];
}



- (IBAction)submit:(id)sender {
    
    if ([_username.text isEqualToString:@""] || [_password.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whooops" message:@"The username or password you entered is incorrect" delegate: nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        [self performSegueWithIdentifier:@"Login" sender:self];
        
        return;
    }
    
    else {
    
    [PFUser logInWithUsernameInBackground:_username.text password:_password.text block:^(PFUser *user, NSError *error) {
        if (error) {
            
             NSLog(@"Error while logging in");
            
            return;
            
            
        }
        else if (!error) {
            
            NSLog(@"Login user");
            
            _username.text = _username.text;
            
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
