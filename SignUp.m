//
//  UITableViewController+SignUp.m
//  Eagle
//
//  Created by Kishon Daniels on 6/11/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "SignUp.h"
#import "PAWActivityView.h"
#import "EventTableView.h"

@interface SignUp()

@end

@implementation SignUp

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    
    title.text=@"Sign Up";
    
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    [title setFont:font];
    self.navigationItem.titleView = title;

    
    self.tableView.tableFooterView = [UIView new];
    
    _email.delegate = self;
    _password.delegate = self;
    _username.delegate = self;

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [_email becomeFirstResponder];
}


#pragma mark - UI

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 5;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    }
    if (textField == self.password) {
        [self.confirm becomeFirstResponder];
    }
    if (textField == self.confirm) {
        [self.confirm resignFirstResponder];
        
        [self processFieldEntries];
    }
    
    return YES;
}

- (IBAction)registerButton:(id)sender {

   [self processFieldEntries];

 }


- (void)processFieldEntries {
    
    // Check that we have a non-zero username and passwords.
    // Compare password and passwordAgain for equality
    // Throw up a dialog that tells them what they did wrong if they did it wrong.
    
    NSString *username = self.username.text;
    NSString *email = self.email.text;
    NSString *password = self.password.text;
    NSString *passwordAgain = self.confirm.text;
    NSString *errorText = @"Please ";
    NSString *usernameBlankText = @"enter a username";
    NSString *emailBlankText = @"enter an email";
    NSString *passwordBlankText = @" enter a password";
    NSString *joinText = @", and ";
    NSString *passwordMismatchText = @"enter the same password twice";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (passwordAgain.length == 0) {
            [self.confirm becomeFirstResponder];
            NSLog(@"password not confirmed");
        }
        if (password.length == 0) {
            [self.password becomeFirstResponder];
            
            NSLog(@"password not entered");
        }
        if (username.length == 0) {
            [self.username becomeFirstResponder];
            
            NSLog(@"no username offered");
        }
        if (email.length == 0) {
            [self.email becomeFirstResponder];
            
            NSLog(@"no email offered");
            
        }
        
        if (email.length == 0) {
            errorText = [errorText stringByAppendingString:emailBlankText];
        }
        if (username.length == 0) {
            errorText = [errorText stringByAppendingString:usernameBlankText];
        }
        
        if (password.length == 0 || passwordAgain.length == 0) {
            if (username.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:passwordBlankText];
        }
    } else if ([password compare:passwordAgain] != NSOrderedSame) {
        // We have non-zero strings.
        // Check for equal password strings.
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordMismatchText];
        [self.password becomeFirstResponder];
    }
    
    if (textError) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
        
    }
    
    // Everything looks good; try to log in.
    PAWActivityView *activityView = [[PAWActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Signing You Up";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    // Call into an object somewhere that has code for setting up a user.
    // The app delegate cares about this, but so do a lot of other objects.
    // For now, do this inline.
    
    PFUser *user = [PFUser user];
    user.email = email;
    user.username = username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        if (error)  {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            [activityView.activityIndicator stopAnimating];
            [activityView removeFromSuperview];
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.username becomeFirstResponder];
            
            return;
        }
        
        else  if (!error) {
            
            // Success!
            [activityView.activityIndicator stopAnimating];
            [activityView removeFromSuperview];
            
            NSLog(@"successful register");
            
            [self performSegueWithIdentifier:@"register" sender:self];
            
            
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
