//
//  UIViewController+EventDetail.h
//  Eagle
//
//  Created by Kishon Daniels on 1/7/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <ParseUI/ParseUI.h>

@interface EventDetail : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *posts;
    NSArray *users;
    
}
@property (nonatomic, strong) IBOutlet UITableView *userTable;
@property (nonatomic, weak) IBOutlet UILabel *eventName;
@property (nonatomic, weak) IBOutlet UILabel *address;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFObject *post;
@property (nonatomic ,strong) PFObject *event;
@property (nonatomic, strong) PFObject *attendingUser;
@property (nonatomic, strong) IBOutlet PFImageView *eventImage;
@property (nonatomic, strong) PFImageView *userPhoto;
@property (nonatomic ,strong) UILabel *username;
@property (nonatomic, strong) IBOutlet UIButton *attending;

@property (nonatomic, strong) UITextField *textField;

- (IBAction)attending:(id)sender;



@end
