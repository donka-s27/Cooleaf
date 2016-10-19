//
//  NPSettings.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLSettings : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) BOOL sendDailyDigest;
@property (nonatomic, assign) BOOL sendWeeklyDigest;

@end
