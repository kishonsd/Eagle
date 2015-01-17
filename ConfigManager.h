//
//  NSObject+ConfigManager.h
//  Eagle
//
//  Created by Kishon Daniels on 1/12/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchConfigIfNeeded;

- (NSArray *)filterDistanceOptions;
- (NSUInteger)postMaxCharacterCount;


@end
