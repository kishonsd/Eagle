//
//  UITableViewController+Table.h
//  Table
//
//  Created by Kishon Daniels on 6/9/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Table : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *issues;
    
}

@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UILabel *name;




@end
