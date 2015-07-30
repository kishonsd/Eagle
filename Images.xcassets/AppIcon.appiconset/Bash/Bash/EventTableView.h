//
//  PFQueryTableViewController+EventTableView.h
//  Bash
//
//  Created by Kishon Daniels on 7/28/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

@interface EventTableView : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    
}

@property (nonatomic, strong) UITableView *eventTable;

@end
