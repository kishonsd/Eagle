//
//  UIViewController+Home.m
//  Eagle
//
//  Created by Kishon Daniels on 1/15/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import "Home.h"
#import <QuartzCore/QuartzCore.h>

@implementation Home

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [[_loginButton layer] setBorderWidth:1.0f];
    [[_loginButton layer] setBorderColor:[UIColor whiteColor].CGColor];

    _signUpButton.layer.cornerRadius = 7; // this value varies
    _signUpButton.clipsToBounds = YES;

    _loginButton.layer.cornerRadius = 7; // this value vary as per your desire
    _loginButton.clipsToBounds = YES;

}
@end
