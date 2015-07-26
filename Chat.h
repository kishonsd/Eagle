//
//  PFQueryTableViewController+Chat.h
//  Eagle
//
//  Created by Kishon Daniels on 6/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "TabBar.h"

@class EventTableView;

@protocol EventTableViewDataSource <NSObject>

- (CLLocation *)currentLocationEventTableView:(EventTableView *)controller;

@end

@interface Chat : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, UINavigationControllerDelegate> {
    
    NSArray *posts;
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFObject *post;
@property (nonatomic, weak) UILabel *text;
@property (nonatomic, strong) NSTimer *fetchTimer;
@property (nonatomic, strong) NSArray *items;


@end
