//
//  UIViewController+Comment.m
//  Eagle
//
//  Created by Kishon Daniels on 6/1/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Comment.h"
#import "ConfigManager.h"
#import "ProgressHUD.h"

#define MAX_HEIGHT 2000

@implementation Comment

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _comment.delegate = self;
    
    _textView.delegate = self;
    
    CGRect frameRect = _comment.frame;
    frameRect.size.height = 215;
    _comment.frame = frameRect;
    
    
}

- (void)textViewDidChange:(UITextView *)view

{
    CGFloat fixedWidth = _textView.frame.size.width;
    CGSize newSize = [_textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    _textView.frame = newFrame;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [_comment becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_comment resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    
    NSString *comment = _comment.text;
    
    PFUser *user = [PFUser currentUser];
    PFObject *event = [PFObject objectWithClassName:@"Chat"];
    [event setObject:comment forKey:@"text"];
    [event setObject:user forKey:@"user"];
    
    [ProgressHUD show:@"saving your comment..."];

    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [ProgressHUD dismiss];
            

        }
    }];
    
    
    
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
