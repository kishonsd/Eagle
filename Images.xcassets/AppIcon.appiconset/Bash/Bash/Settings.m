//
//  UITableViewController+Settings.m
//  Bash
//
//  Created by Kishon Daniels on 8/3/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Settings.h"
#import <Parse/Parse.h>

@implementation Settings


- (IBAction)logout:(id)sender {
    
    [PFUser logOut]; // Log out
    
    
    // Return to login page
    if (![PFUser currentUser]) {
        
        [self performSegueWithIdentifier:@"home" sender:self];
 }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (IBAction)cancel:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
