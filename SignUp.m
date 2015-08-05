
//
//  UITableViewController+SignUp.m
//  Eagle
//
//  Created by Kishon Daniels on 1/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "SignUp.h"
#import "KVNProgress.h"


@implementation SignUp

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (KVNProgressConfiguration *)customKVNProgressUIConfiguration
{
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
    
    // See the documentation of KVNProgressConfiguration
    configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"Avenir - Medium" size:15.0f];
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    configuration.backgroundFillColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.0f alpha:0.9f];
    configuration.backgroundTintColor = [UIColor colorWithRed:0.173f green:0.0f blue:0.0f alpha:0.4f];
    configuration.successColor = [UIColor whiteColor];
    configuration.errorColor = [UIColor whiteColor];
    configuration.stopColor = [UIColor whiteColor];
    configuration.circleSize = 110.0f;
    configuration.lineWidth = 1.0f;
    configuration.showStop = YES;
    configuration.stopRelativeHeight = 0.3f;
    
    configuration.tapBlock = ^(KVNProgress *progressView) {
        [KVNProgress dismiss];
    };
    
    return configuration;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.customConfiguration = [self customKVNProgressUIConfiguration];
    
    self.tableView.tableFooterView = [UIView new];
    
    _username.delegate = self;
    _email.delegate = self;
    _password.delegate = self;
    _confirm.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [_email becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [KVNProgress setConfiguration:self.customConfiguration];
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
    return 5;
}

- (IBAction)registerButton:(id)sender {

    [self processFieldEntries];
    
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.email) {
        [self.username becomeFirstResponder];
    }
    if (textField == self.username) {
        [self.confirm becomeFirstResponder];
    }
    if (textField == self.confirm) {
        
        [self.confirm resignFirstResponder];
        [self processFieldEntries];
    }
    
    
    return YES;
}


- (void)processFieldEntries {
    
    //Get information and store it in the app delegate for now
    NSString *email = self.email.text;
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    NSString *confirm = self.confirm.text;
    NSString *errorText = @"Please ";
    NSString *noUsername = @"enter a username";
    NSString *noEmail = @"enter an email";
    NSString *errorTextJoin = @", and ";
    NSString *noPassword = @" enter a password";
    NSString *passwordsDontMatch = @"enter the same password twice";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (email.length == 0 || username.length == 0 || password.length == 0 || confirm.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (confirm.length == 0) {
            [self.confirm becomeFirstResponder];
        }
        if (password.length == 0) {
            [self.password becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.username becomeFirstResponder];
        }
        
        if (email.length == 0) {
            errorText = [errorText stringByAppendingString:noEmail];
        }
        
        if (username.length == 0) {
            errorText = [errorText stringByAppendingString:noUsername];
        }
        
        if (password.length == 0 || confirm.length == 0) {
            if (email.length == 0) {
                
                // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:errorTextJoin];
                
            }
            
            errorText = [errorText stringByAppendingString:noPassword];
        }
        
    }
    
    else if ([password compare:confirm] != NSOrderedSame) {
        
        // We have non-zero strings.
        // Check for equal password strings.
        
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordsDontMatch];
        [self.confirm becomeFirstResponder];
        
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
            
            [self.email becomeFirstResponder];
            

    
   }
        else if (!error) {
        
        [KVNProgress showSuccessWithStatus:@""];
            [self performSegueWithIdentifier:@"register" sender:self];
            
            
        }
        
    }];
}


#pragma mark - Helpers

- (void)updateProgress
{
    dispatch_main_after(2.0f, ^{
        [KVNProgress updateProgress:0.3f
                           animated:YES];
    });
    dispatch_main_after(2.5f, ^{
        [KVNProgress updateProgress:0.5f
                           animated:YES];
    });
    dispatch_main_after(2.8f, ^{
        [KVNProgress updateProgress:0.6f
                           animated:YES];
    });
    dispatch_main_after(3.7f, ^{
        [KVNProgress updateProgress:0.93f
                           animated:YES];
    });
    dispatch_main_after(5.0f, ^{
        [KVNProgress updateProgress:1.0f
                           animated:YES];
    });
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

#pragma mark -
#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
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
