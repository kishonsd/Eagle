//
//  UIViewController+Comment.h
//  Eagle
//
//  Created by Kishon Daniels on 6/1/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetail.h"
#import "Post.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface Comment : UIViewController <UITextFieldDelegate,UITextViewDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) IBOutlet UITextField *comment;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) PFObject *event;
@property (nonatomic, strong) PFObject *object;

- (IBAction)cancel:(id)sender;

- (IBAction)submit:(id)sender;

@end
