//
//  UIViewController+EventDetail.m
//  Eagle
//
//  Created by Kishon Daniels on 1/7/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "EventDetail.h"


@implementation EventDetail



- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self)
    {
        self.parseClassName = @"User";
        self.textKey = @"";
        self.imageKey = @"eventImage";
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
    
    //Load all labels and event image to view
    self.eventName.text = [self.event objectForKey:@"title"];
    self.address.text = [self.event objectForKey:@"address"];
    self.date.text = [self.event objectForKey:@"date"];
    self.eventImage.image = [[UIImage alloc] initWithData: [[self.event objectForKey:@"eventImage"] getData]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self->users = [NSArray array];
    [self performSelector: @selector(retrieveFromParse)];
    
    self.eventImage.layer.cornerRadius = self.eventImage.frame.size.width / 2;
    self.eventImage.clipsToBounds = YES;
    
    self.navigationController.toolbarHidden = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    // Return the number of sections.
    if (_event) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No one is attending this event";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [users count];
}

- (void)retrieveFromParse {
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (IBAction)attending:(id)sender {
    
    PFObject *event = [PFObject objectWithClassName:@"Posts"];
    PFUser *user =[PFUser currentUser];
    [event addObject:[PFUser currentUser] forKey:@"attending"];
    [user saveInBackground];

}

@end
