//
//  UITableViewController+Hosting.m
//  Eagle
//
//  Created by Kishon Daniels on 1/10/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Hosting.h"
#import "MBProgressHud.h"
#import "ConfigManager.h"
#import "Constants.h"
#import "MapPostsView.h"
#import "EventTableView.h"

@implementation Hosting
@synthesize locationManager;


-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    _name.delegate = self;
    _location.delegate = self;
    _time.delegate = self;
    
    self.addPhoto.layer.cornerRadius = self.addPhoto.frame.size.width / 2;
    self.addPhoto.clipsToBounds = YES;
    self.addEventImage.layer.cornerRadius = self.addEventImage.frame.size.width / 2;
    self.addEventImage.clipsToBounds = YES;
    
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 144.0f, 26.0f)];
    self.characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 144.0f, 21.0f)];
    self.characterCountLabel.backgroundColor = [UIColor clearColor];
    self.characterCountLabel.textColor = [UIColor darkGrayColor];
    [accessoryView addSubview:self.characterCountLabel];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

}

-(CLLocation*)currentLocation:(Hosting*)controller {
    return 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [_name becomeFirstResponder];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSLog(@"View appeared");
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
    NSLog(@"View disappeared");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 3;
}

- (void)showPhotoLibary
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showPhotoLibary];
    }
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.addPhoto.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_name resignFirstResponder];
    [_location resignFirstResponder];
    [_time resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)addPhoto:(id)sender {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];

}
-(IBAction)submit:(id)sender {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (error) {
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You must turn on your location services to post an event" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        if (!error) {
             NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            [self saveEvent];
        }
    }];
}

- (void)saveEvent {
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            // Data prep:
            // Stitch together a postObject and send this async to Parse
            NSString *title = _name.text;
            NSString *location = _location.text;
            NSString *time = _time.text;
            PFObject *event = [PFObject objectWithClassName:@"Posts"];
            [event setObject:title forKey:@"title"];
            [event setObject:location forKey:@"address"];
            [event setObject:time forKey:@"date"];
            [event setObject:geoPoint forKey:@"eventLocation"];
            [event setObject:[PFUser currentUser] forKey:@"Host"];
            
            // image
            NSData *imageData = UIImageJPEGRepresentation(_addPhoto.image, 0.8);
            NSString *filename = [NSString stringWithFormat:@"%@.png", _name.text];
            PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
            [event setObject:imageFile forKey:@"eventImage"];
            
            PFACL *defaultACL = [PFACL ACL];
            [defaultACL setPublicReadAccess:YES];
            [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
                          
            
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    
    // Upload to Parse
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the event" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    }];
        }
    }];
}


- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
