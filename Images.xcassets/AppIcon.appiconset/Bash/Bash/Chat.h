//
//  PFQueryTableViewController+Chat.h
//  Bash
//
//  Created by Kishon Daniels on 7/30/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface Chat : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate> {
    
    NSArray *posts;
    
}

@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;

@end
