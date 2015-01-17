//
//  UIViewController+MapPostsView.h
//  Eagle
//
//  Created by Kishon Daniels on 1/13/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@class MapPostsView;

@protocol MapPostsViewDelegate <NSObject>

- (void)mapPostsViewWantsToPresentSettings:(MapPostsView *)controller;

@end

@class Post;

@interface MapPostsView : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate , MKAnnotation> {
    NSArray *posts;
}

@property (nonatomic, weak) id<MapPostsViewDelegate> delegate;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic,strong) PFGeoPoint *geopPoint;

- (IBAction)postButtonSelected:(id)sender;
@property double latitude;
@property double longitude;
@end

@protocol MapPostsViewHighlight <NSObject>

- (void)highlightCellForPost:(Post *)post;
- (void)unhighlightCellForPost:(Post *)post;


@end
