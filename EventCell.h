//
//  PFTableViewCell+EventCell.h
//  Eagle
//
//  Created by Kishon Daniels on 1/7/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface EventCell : PFTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *location;
@property (nonatomic, strong) IBOutlet UILabel *time;

@property (nonatomic, strong) IBOutlet PFImageView *eventImage;

@end
