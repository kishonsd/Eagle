//
//  UIViewController+EventDetail.h
//  Eagle
//
//  Created by Kishon Daniels on 1/7/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <ParseUI/ParseUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Comment.h"

@interface EventDetail : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>  {
    
    NSArray *images;
   
    BOOL buttonCurrentStatus;
    
}

@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, weak) IBOutlet UILabel *eventName;
@property (nonatomic, weak) IBOutlet UILabel *location;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UILabel *detail;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) IBOutlet UIButton *attending;
@property (nonatomic, weak) PFObject *event;
@property (nonatomic, strong) PFObject *comment;
@property (nonatomic, strong) PFObject *attendingUser;
@property (nonatomic, strong) IBOutlet PFImageView *photo;
@property (nonatomic, strong) IBOutlet UITableView *commentTable;
@property (nonatomic, strong) IBOutlet UICollectionView *image;
@property (nonatomic, strong) IBOutlet UIImage *userPhoto;



- (IBAction)attending:(id)sender;
- (IBAction)dismiss:(id)sender;

@end
