//
//  Localization.h
//  Eagle
//
//  Created by Kishon Daniels on 6/4/15.
//  Copyright (c) 2015 HackStack. All rights reserved.
//

#ifndef Eagle_Localization_h
#define Eagle_Localization_h

#undef NSLocalizedString
#define NSLocalizedString(key, comment) \
[[NSBundle mainBundle] localizedStringForKey:key value:nil table:@"ParseUI"]

#endif

