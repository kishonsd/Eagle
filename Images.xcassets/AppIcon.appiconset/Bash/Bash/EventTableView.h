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
#import "Post.h"
#import "Hideable.h"


@interface EventTableView : PFQueryTableViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    
    NSArray *posts;
    
}

@property (nonatomic, strong) IBOutlet UITableView *eventTable;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFImageView *eventImage;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;

@end
