//
//  UITabBarController+TabController.h
//  Eagle
//
//  Created by Kishon Daniels on 1/13/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>


@interface TabController : UITabBarController <CLLocationManagerDelegate>
@property (nonatomic,strong) PFGeoPoint *geopPoint;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end
