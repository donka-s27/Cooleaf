//
//  CLSeries.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLSeries.h"

@implementation CLSeries

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"seriesId": @"id",
             @"eventIds": @"event_ids"
             };
}


# pragma mark - eventIdJSONTransformer

- (NSValueTransformer *)eventIdsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:NSNumber.class];
}

@end
