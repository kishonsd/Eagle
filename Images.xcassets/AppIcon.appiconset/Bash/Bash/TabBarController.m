//
//  UITabBarController+TabController.m
//  Bash
//
//  Created by Kishon Daniels on 7/28/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "TabBarController.h"

#define TABBAR_HEIGHT (49)

@implementation UITabBarController

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    NSLog(@"setTabBarHidden:%d animated:%d", hidden, animated);
    
    if ( [self.view.subviews count] < 2 )
        return;
    
    UIView *contentView;
    
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.view.subviews objectAtIndex:1];
    else
        contentView = [self.view.subviews objectAtIndex:0];
    
    
    if(hidden)
    {
        if(animated)
        {
            NSLog(@"HIDDEN - ANIMATED");
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 contentView.frame = self.view.bounds;
                                 
                                 self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }
                             completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }];
        }
        else
        {
            NSLog(@"HIDDEN");
            
            contentView.frame = self.view.bounds;
            
            self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.size.height,
                                           self.view.bounds.size.width,
                                           TABBAR_HEIGHT);
        }
    }
    else
    {
        self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.size.height,
                                       self.view.bounds.size.width,
                                       0);
        if(animated)
        {
            NSLog(@"NOT HIDDEN - ANIMATED");
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.size.height - TABBAR_HEIGHT,
                                                                self.view.bounds.size.width,
                                                                TABBAR_HEIGHT);
                             }   completion:^(BOOL finished) {
                                 contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                                                self.view.bounds.origin.y,
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height - TABBAR_HEIGHT);
                             }];
        }
        else
        {
            NSLog(@"NOT HIDDEN");
            contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.origin.y,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - TABBAR_HEIGHT);
            
            self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                           self.view.bounds.size.height - TABBAR_HEIGHT,
                                           self.view.bounds.size.width,
                                           TABBAR_HEIGHT);
        }
    }
}

@end
