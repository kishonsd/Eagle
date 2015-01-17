//
//  UITableViewController+Hosting.h
//  Eagle
//
//  Created by Kishon Daniels on 1/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>


@class Hosting;

@protocol HostingDataSource <NSObject>

- (CLLocation *)currentLocationForHosting:(Hosting *)controller;

@end

@interface Hosting : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, CLLocationManagerDelegate,NSObject>
@property (nonatomic, weak) id<HostingDataSource> dataSource;
@property(nonatomic,strong) PFObject *event;
@property (nonatomic, strong) PFGeoPoint *geoLocation;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *location;
@property (nonatomic, strong) IBOutlet UITextField *time;
@property (nonatomic, strong) IBOutlet UIImageView *addPhoto;
@property (nonatomic, strong) IBOutlet UIButton *addEventImage;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, assign) NSUInteger maximumCharacterCount;
@property (nonatomic, strong) PFObject *user;
- (CLLocation *)currentLocation:(Hosting *)controller;
-(IBAction)submit:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)addPhoto:(id)sender;

@end
