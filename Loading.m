//
//  UIView+Loading.m
//  Eagle
//
//  Created by Kishon Daniels on 6/4/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Loading.h"

@interface Loading()


@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation Loading


#pragma mark -
#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator startAnimating];
        [self addSubview:_activityIndicator];
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.text = NSLocalizedString(@"Loading...", @"Loading message of PFQueryTableViewController");
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _loadingLabel.shadowColor = [UIColor whiteColor];
        [_loadingLabel sizeToFit];
        [self addSubview:_loadingLabel];
    }
    return self;
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGRect bounds = self.bounds;
    
    CGFloat viewsInset = 4.0f;
    CGFloat startX = floorf((CGRectGetMaxX(bounds)
                             - CGRectGetWidth(_loadingLabel.frame)
                             - CGRectGetWidth(_activityIndicator.frame)
                             - viewsInset)
                            / 2.0f);
    
    CGRect activityIndicatorFrame = PFRectMakeWithSizeCenteredInRect(_activityIndicator.frame.size, bounds);
    activityIndicatorFrame.origin.x = startX;
    _activityIndicator.frame = activityIndicatorFrame;
    
    CGRect loadingLabelFrame = PFRectMakeWithSizeCenteredInRect(_loadingLabel.frame.size, bounds);
    loadingLabelFrame.origin.x = CGRectGetMaxX(activityIndicatorFrame) + viewsInset;
    _loadingLabel.frame = loadingLabelFrame;
}
@end
