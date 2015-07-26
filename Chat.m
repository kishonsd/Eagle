
//
//  PFQueryTableViewController+Chat.m
//  Eagle
//
//  Created by Kishon Daniels on 6/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Chat.h"

@implementation Chat

- (id)initWithCoder:(NSCoder *)aCoder

{
    self = [super initWithCoder:aCoder];
    if (self)
        
    {
        self.parseClassName = @"Chat";
        self.textKey = @"text";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 100;
        
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:3600
                                             target:(id)self
                                           selector:@selector(fetch)
                                           userInfo:nil
                                            repeats:YES];
    self.fetchTimer = timer;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width,40)];
    
    title.text = @"Chat";
    
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Heavy" size:20];
    [title setFont:font];
    self.navigationItem.titleView = title;
    
    
    NSLog(@"hello");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu posts.", (unsigned long)objects.count);
            self->posts = objects;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self->locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self->locationManager requestWhenInUseAuthorization];
        
    }
    
    [self->locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
            
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"kCLAuthorizationStatusAuthorized");
            // Re-enable the post button if it was disabled before.
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self->locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"To view nearby events you must give Bash access in the Settings app under Location Services." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Settings", nil];
            
            [alertView show];
            
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"kCLAuthorizationStatusRestricted");
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self->posts count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject*)object
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    UILabel *title = (UILabel*) [cell viewWithTag:1];
    title.text = [object objectForKey:@"text"];
    
    return cell;
    
    
}

@end
