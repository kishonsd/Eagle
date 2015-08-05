//
//  UITableViewController+Settings.h
//  Bash
//
//  Created by Kishon Daniels on 8/3/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, strong) UITableView *settingsTable;

- (IBAction)cancel:(id)sender;

@end
