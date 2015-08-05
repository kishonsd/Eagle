//
//  NSObject+Post.h
//  Bash
//
//  Created by Kishon Daniels on 7/30/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface Post : NSObject

@property (nonatomic, strong) UILabel *eventName;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) PFImageView *eventImage;

@end
