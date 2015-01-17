//
//  UIViewController+MapPostsView.m
//  Eagle
//
//  Created by Kishon Daniels on 1/13/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "MapPostsView.h"
#import "Constants.h"
#import "Post.h"
#import "Hosting.h"
#import "EventTableView.h"
#import "EventDetail.h"

@interface MapPostsView ()
<EventTableViewDataSource,
HostingDataSource>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) MKCircle *circleOverlay;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;
@property (nonatomic, strong) PFQueryTableViewController *query;
@property (nonatomic, strong) EventTableView *eventTableViewController;

@property (nonatomic, strong) NSMutableArray *allPosts;

@end

@implementation MapPostsView
@synthesize coordinate;

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Peak";
        
        _annotations = [[NSMutableArray alloc] initWithCapacity:10];
        _allPosts = [[NSMutableArray alloc] initWithCapacity:10];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(distanceFilterDidChange:)
                                                     name:FilterDistanceDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(postWasCreated:)
                                                     name:PostCreatedNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [_locationManager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FilterDistanceDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PostCreatedNotification object:nil];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self eventTableViewController];
    
    self.mapPannedSinceLocationUpdate = NO;
    [self startStandardUpdates];
    
    if (nil == self.locationManager){
        
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        
        //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // Set a movement threshold for new events.
        
        self.locationManager.distanceFilter = 500; // meters
        
        [self.locationManager startUpdatingLocation];
        
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager requestAlwaysAuthorization]; 

    }
    
    self.mapView.delegate = self;
    
    // Map will show current location
    
    self.mapView.showsUserLocation = YES;
    
    
    // Maps' opening spot
    
    self.location = [self.locationManager location];
    
    CLLocationCoordinate2D coordinateActual = [self.location coordinate];
    
    // Map's zoom
    
    MKCoordinateSpan zoom = MKCoordinateSpanMake(0.010, 0.010);
    
    // Create a region
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinateActual, zoom);
    
    // Method which sets exibition method
    
    [self.mapView setRegion:region animated:YES];
    
    //Map's type
    
    self.mapView.mapType = MKMapTypeStandard;
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.locationManager startUpdatingLocation];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark DataSource

- (CLLocation *)currentLocationEventTableView:(EventTableView *)controller {
    return self.currentLocation;
}

#pragma mark -
#pragma mark WallPostCreatViewController

- (void)presentHosting {
    Hosting *viewController = [[Hosting alloc] initWithNibName:nil bundle:nil];
    viewController.dataSource = self;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark DataSource

- (CLLocation *)currentLocationForHosting:(Hosting *)controller {
    return self.currentLocation;
}

#pragma mark -
#pragma mark NSNotificationCenter notification handlers

- (void)distanceFilterDidChange:(NSNotification *)note {
    CLLocationAccuracy filterDistance = [[note userInfo][kFilterDistanceKey] doubleValue];
    
    if (self.circleOverlay != nil) {
        [self.mapView removeOverlay:self.circleOverlay];
        self.circleOverlay = nil;
    }
    self.circleOverlay = [MKCircle circleWithCenterCoordinate:self.currentLocation.coordinate radius:filterDistance];
    [self.mapView addOverlay:self.circleOverlay];
    
    // Update our pins for the new filter distance:
    [self updatePostsForLocation:self.currentLocation withNearbyDistance:filterDistance];
    
    // If they panned the map since our last location update, don't recenter it.
    if (!self.mapPannedSinceLocationUpdate) {
        // Set the map's region centered on their location at 2x filterDistance
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, filterDistance * 2.0f, filterDistance * 2.0f);
        
        [self.mapView setRegion:newRegion animated:YES];
        self.mapPannedSinceLocationUpdate = NO;
    } else {
        // Just zoom to the new search radius (or maybe don't even do that?)
        MKCoordinateRegion currentRegion = self.mapView.region;
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(currentRegion.center, filterDistance * 2.0f, filterDistance * 2.0f);
        
        BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
        [self.mapView setRegion:newRegion animated:YES];
        self.mapPannedSinceLocationUpdate = oldMapPannedValue;
    }
}

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.currentLocation == currentLocation) {
        return;
    }
    
    _currentLocation = currentLocation;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CurrentLocationDidChangeNotification
                                                            object:nil
                                                          userInfo:@{ kLocationKey : currentLocation } ];
    });
    
    CLLocationAccuracy filterDistance = [[NSUserDefaults standardUserDefaults] doubleForKey:UserDefaultsFilterDistanceKey];
    
    // If they panned the map since our last location update, don't recenter it.
    if (!self.mapPannedSinceLocationUpdate) {
        // Set the map's region centered on their new location at 2x filterDistance
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, filterDistance * 2.0f, filterDistance * 2.0f);
        
        BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
        [self.mapView setRegion:newRegion animated:YES];
        self.mapPannedSinceLocationUpdate = oldMapPannedValue;
    } // else do nothing.
    
    if (self.circleOverlay != nil) {
        [self.mapView removeOverlay:self.circleOverlay];
        self.circleOverlay = nil;
    }
    self.circleOverlay = [MKCircle circleWithCenterCoordinate:self.currentLocation.coordinate radius:filterDistance];
    [self.mapView addOverlay:self.circleOverlay];
    
    // Update the map with new pins:
    [self queryForAllPostsNearLocation:self.currentLocation withNearbyDistance:filterDistance];
    // And update the existing pins to reflect any changes in filter distance:
    [self updatePostsForLocation:self.currentLocation withNearbyDistance:filterDistance];
}

- (void)postWasCreated:(NSNotification *)note {
    CLLocationAccuracy filterDistance = [[NSUserDefaults standardUserDefaults] doubleForKey:UserDefaultsFilterDistanceKey];
    [self queryForAllPostsNearLocation:self.currentLocation withNearbyDistance:filterDistance];
}

#pragma mark -
#pragma mark UINavigationBar-based actions

- (IBAction)settingsButtonSelected:(id)sender {
    [self.delegate mapPostsViewWantsToPresentSettings:self];
}

- (IBAction)postButtonSelected:(id)sender {
    [self presentHosting];
    [self performSegueWithIdentifier:@"NewPost" sender:self];
    NSLog(@"Going to create new post");
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods and helpers

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Set a movement threshold for new events.
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (void)startStandardUpdates {
    [self.locationManager startUpdatingLocation];
    
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"kCLAuthorizationStatusAuthorized");
            // Re-enable the post button if it was disabled before.
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Peak can’t access your current location.\n\nTo view nearby events or set an event at your current location, turn on access for Peak to your location in the Settings app under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
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

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Error: %@", [error description]);
    
    if (error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if (error.code == kCLErrorLocationUnknown) {
        // todo: retry?
        // set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:self.circleOverlay];
        [circleRenderer setFillColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.2f]];
        [circleRenderer setStrokeColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.7f]];
        [circleRenderer setLineWidth:1.0f];
        return circleRenderer;
    }
    return nil;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *MapViewAnnotationIdentifier = @"places_coordinate";
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:self.annotation reuseIdentifier:MapViewAnnotationIdentifier];
    
    pin.canShowCallout = YES;
    
    pin.animatesDrop = YES;
    
    return pin;
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
 [self performSegueWithIdentifier:@"showDetail" sender:view];
      
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"])
    {
        MKAnnotationView *annotationView = sender;
        [segue.destinationViewController setAnnotation:annotationView.annotation];
    }
}

#pragma mark -
#pragma mark Fetch map pins

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
    
    PFQuery *query = [PFQuery queryWithClassName:PostsClassName];

    
    if (currentLocation == nil) {
        NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.allPosts count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // Query for posts sort of kind of near our current location.
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    [query whereKey:PostLocationKey nearGeoPoint:point withinMiles:25];
    [query includeKey:@"Host"];
    
    query.limit = 50;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
             NSLog(@"%@", objects);
            
            for (PFObject *object in posts) {
                
                
                PFGeoPoint *point = [object objectForKey:@"eventLocation"];
                
                MKPointAnnotation *geoPointAnnotation = [[MKPointAnnotation alloc]
                                                         init];
                
                geoPointAnnotation.coordinate = CLLocationCoordinate2DMake(point.latitude, offerPoint.longitude);
                
                [self.mapView addAnnotation:geoPointAnnotation];
                
                NSLog(@"Annotation: %@",geoPointAnnotation);
            }
            }
        }];
    
}

// When we update the search filter distance, we need to update our pins' titles to match.
- (void)updatePostsForLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy) nearbyDistance {
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
        if (!error) {

    PFObject *location = [PFObject objectWithClassName:@"Posts"];
    
    //Create a point for markers
    
    PFGeoPoint *point = location[@"eventLocation"];
    
    // Check current Location
    
    NSLog(@"%@", point);
    
    // Create a query for Places of interest near current location
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    
    [query whereKey:@"eventLocation" nearGeoPoint:geoPoint withinMiles:20.0];
    
    NSLog(@"Query: %@",query);
    
    // Limit the query
    
    query.limit = 10;
    
    // Store objects in the array
    NSArray *objects = [query findObjects];
    
    NSLog(@"Array: %@",objects);
    
    if (!error) {
        
        for (PFObject *object in objects) {
            
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            PFGeoPoint *geoPoint= [object objectForKey:@"eventLocation"];
            annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude,geoPoint.longitude);
            _image = [object objectForKey:@"eventImage"];
            
            annotation.title = [object objectForKey:@"title"];
            annotation.subtitle = [object objectForKey:@"date"];
            annotation.subtitle = [object objectForKey:@"address"];
            
            [self.mapView addAnnotation:annotation];
            
            //Annotation *geoPointAnnotation = [[Annotation alloc]
            //initWithObject:object];
            //[self.mapView1 addAnnotation:geoPointAnnotation];
        }
        }
        }
    }];

        }

@end
