//
//  PFQueryTableViewController+UserProfile.h
//  Bash
//
//  Created by Kishon Daniels on 7/28/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface UserProfile : PFQueryTableViewController <UITableViewDataSource, UITableViewDataSource> {
    
    NSArray *posts;
}

@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;

@end
