//
//  CLTimeZone.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLTimeZone.h"

@implementation CLTimeZone

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"offset": @"offset",
             @"abbrv": @"abbreviation",
             @"momentName": @"moment_name"
             };
}

@end
