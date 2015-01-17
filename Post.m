//
//  NSObject+Post.m
//  Eagle
//
//  Created by Kishon Daniels on 1/13/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Post.h"
#import "Constants.h"

@interface Post ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation Post

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          andTitle:(NSString *)title
                       andSubtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

- (instancetype)initWithPFObject:(PFObject *)object {
    [object fetchIfNeeded];
    
    PFGeoPoint *geoPoint = object[@"eventLocation"];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    NSString *title = object[@"title"];
    NSString *subtitle = object[@"date"];
    
    self = [self initWithCoordinate:coordinate andTitle:title andSubtitle:subtitle];
    if (self) {
        self.object = object;
    }
    return self;
}

#pragma mark -
#pragma mark Equal

- (BOOL)isEqual:(id)other {
    if (![other isKindOfClass:[Post class]]) {
        return NO;
    }
    
    Post *post = (Post *)other;
    
    if (post.object && self.object) {
        // We have a PFObject inside the PAWPost, use that instead.
        return [post.object.objectId isEqualToString:self.object.objectId];
    }
    
    // Fallback to properties
    return ([post.title isEqualToString:self.title] &&
            [post.subtitle isEqualToString:self.subtitle] &&
            post.coordinate.latitude == self.coordinate.latitude &&
            post.coordinate.longitude == self.coordinate.longitude);
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
    if (outside) {
        self.title = kCantViewPost;
        self.subtitle = nil;
        self.pinColor = MKPinAnnotationColorRed;
    } else {
        self.title = self.object[PostTextKey];
        self.subtitle = self.object[PostUserKey][PostNameKey] ?:
        self.object[PostUserKey][PostUsernameKey];
        self.pinColor = MKPinAnnotationColorGreen;
    }
}

@end
