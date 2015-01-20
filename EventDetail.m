//
//  UIViewController+EventDetail.m
//  Eagle
//
//  Created by Kishon Daniels on 1/7/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "EventDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "TabController.h"
#import "Cache.h"

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


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
   
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [_attending setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_attending setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    
    [_attending addTarget:self action:@selector(attending:) forControlEvents:UIControlEventTouchUpInside];
    
    //Load all labels and event image to view
    self.eventName.text = [self.event objectForKey:@"title"];
    self.address.text = [self.event objectForKey:@"address"];
    self.date.text = [self.event objectForKey:@"date"];
    self.eventImage.image = [[UIImage alloc] initWithData: [[self.event objectForKey:@"eventImage"] getData]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.eventImage.layer.cornerRadius = self.eventImage.frame.size.width / 2;
    self.eventImage.clipsToBounds = YES;
    
    self.navigationController.toolbarHidden = YES;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [users count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    
    [query includeKey:@"going.user"];
    
    [query includeKey:@"username"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"profilePic"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    cell.textLabel.text = [object objectForKey:@"username"];
    
    return cell;
}

- (IBAction)attending:(id)sender {
    
    NSLog(@"Touch");
     UIButton *button = (UIButton *)sender;
    button.selected = !button.selected ;
    
    // increment the episode's counter
    [_event incrementKey:@"attending"];
  
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
    [activity setObject:[PFUser currentUser] forKey:@"going"];
    [activity setObject:_event forKey:@"event"];
    [activity saveInBackground];
    
}


@end
