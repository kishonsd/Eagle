//
//  UITabBarController+TabController.m
//  Eagle
//
//  Created by Kishon Daniels on 1/13/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import "TabController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@implementation TabController
- (void)viewDidLoad {
    [super viewDidLoad];
    
self.locationManager = [[CLLocationManager alloc] init];
self.locationManager.delegate = self;
    
#ifdef __IPHONE_8_0
if(IS_OS_8_OR_LATER)
{
    // Use one or the other, not both. Depending on what you put in info.plist
    
    [self.locationManager requestWhenInUseAuthorization];
    
   }
    
#endif
    
[self.locationManager startUpdatingLocation];
    
 }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
        }
    }];
}

@end
