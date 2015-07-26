//
//  UIViewController+EventDetail.m
//  Eagle
//
//  Created by Kishon Daniels on 1/7/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "EventDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "Comment.h"

@implementation EventDetail

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self)
    {
        self.parseClassName = @"Activity";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;

    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [_commentTable reloadData];
   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];

    [_attending setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [_attending setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];

    
    _attending.layer.cornerRadius = 4; // this value varies
    _attending.clipsToBounds = YES;
                                            
    [_attending setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_attending setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_attending addTarget:self action:@selector(attending:) forControlEvents:UIControlEventTouchUpInside];
    
    //Load all labels and event image to view
    self.eventName.text = [self.event objectForKey:@"title"];
    self.location.text = [self.event objectForKey:@"address"];
    self.date.text = [self.event objectForKey:@"date"];
    self.detail.text = [self.event objectForKey:@"detail"];
    self.photo.image = [[UIImage alloc] initWithData: [[self.event objectForKey:@"eventImage"] getData]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            self->images = objects;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.image reloadData];
            });
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@", error);
        }
    }];


    
    
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return[images count];
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    PFObject *imageObject = [images objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error){
            NSLog(@"is there any data? %@", data);
            
        }
        else {
            NSLog(@"no data!");
        }
    }];
    
    return cell;
}

- (IBAction)addPhoto:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share photo from where?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Photo Album", @"Camera", nil];
    
    [actionSheet showInView:self.view];

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


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Configure the cell
    PFFile *thumbnail = [_object objectForKey:@"profilePic"];

    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];

    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];

    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];

    if (buttonIndex == 0) {
    
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
    
    if (buttonIndex == 1) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        
        
    }
    
- (void)imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSData *imageData = UIImagePNGRepresentation(_userPhoto);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile save];
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    PFObject *userPhoto = [PFObject objectWithClassName:@"Photos"];
    [userPhoto setObject:chosenImage forKey:@"image"];
    [userPhoto save];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)attending:(id)sender {
    /* if we have multiple buttons, then we can
     differentiate them by tag value of button.*/
    // But note that you have to set the tag value before use this method.
    
    if([sender tag] == 0 )
    
    {
        
        if (buttonCurrentStatus == NO)
        {
            buttonCurrentStatus = YES;
            [self incrementBookmark];
        }
        else
        {
            buttonCurrentStatus = NO;
            [self decrementBookmark];
        }   
    }
    
    PFObject *event = [PFObject objectWithClassName:@"Posts"];
    // Set a new value on quantity
    [event setObject:@1 forKey:@"liked"];
    
<<<<<<< HEAD
=======
    NSLog(@"Touch");

     UIButton *button = (UIButton *)sender;
    button.selected = !button.selected ;
>>>>>>> origin/master
    
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];

    [activity setObject:[PFUser currentUser] forKey:@"going"];
<<<<<<< Updated upstream
=======
<<<<<<< HEAD
    [activity setObject:self.event forKey:@"event"];
    //Save
=======
>>>>>>> Stashed changes

    [activity setObject:_event forKey:@"event"];
>>>>>>> origin/master
    [activity saveInBackground];
    
    
}



- (void)incrementBookmark {
  
    

}

- (void)decrementBookmark {
    
}

- (void)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
