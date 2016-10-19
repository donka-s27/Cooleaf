//
//  NPSettings.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLSettings.h"

@implementation CLSettings

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"sendDailyDigest": @"send_daily_digest",
             @"sendWeeklyDigest": @"send_weekly_digest"
             };
}

@end
