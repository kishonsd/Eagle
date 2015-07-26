//
//  Constants.h
//  Eagle
//
//  Created by Kishon Daniels on 1/12/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <Parse/Parse.h>

#ifndef Eagle_Constants_h
#define Eagle_Constants_h

static double const DefaultFilterDistance = 1000.0;
static double const PostMaximumSearchDistance = 100.0; // Value in kilometers

static NSUInteger const PostsSearchDefaultLimit = 20; // Query limit for pins and tableviewcells

// Parse API key constants:
static NSString * const PostsClassName = @"Posts";
static NSString * const PostUsernameKey = @"eventName";
static NSString * const PostUserKey = @"User";
static NSString * const PostLocationKey = @"eventLocation";
static NSString * const PostTextKey = @"text";
static NSString * const PostNameKey = @"title";
static NSString * const PostDateKey = @"date";
static NSString * const PostName = @"post";
static NSString * const Attending = @"going";
// NSNotification userInfo keys:
static NSString * const kFilterDistanceKey = @"filterDistance";
static NSString * const kLocationKey = @"currentLocation";

// Notification names:
static NSString * const FilterDistanceDidChangeNotification = @"FilterDistanceDidChangeNotification";
static NSString * const CurrentLocationDidChangeNotification = @"CurrentLocationDidChangeNotification";
static NSString * const PostCreatedNotification = @"PostCreatedNotification";

// UI strings:
static NSString * const kCantViewPost = @"Can’t view post! Get closer.";

// NSUserDefaults
static NSString * const UserDefaultsFilterDistanceKey = @"filterDistance";

typedef double LocationAccuracy;


#endif

