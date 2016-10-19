//
//  CLEvent.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLEvent.h"

@implementation CLEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"eventId": @"id",
             @"address": @"address",
             @"eventDescription": @"description",
             @"name": @"name",
             @"eventImage": @"image",
             @"eventParticipants": @"participants",
             @"participantsCount": @"participants_count",
             @"timeZone": @"timezone",
             @"startTime": @"start_time",
             @"lastStartTime": @"last_start_time",
             @"endTime": @"end_time",
             @"rewardPoints": @"reward_points",
             @"isPast": @"past",
             @"isJoinable": @"joinable",
             @"isAttending": @"attending",
             @"isPaid": @"paid",
             @"eventSeries": @"series",
             @"coordinator": @"coordinator"
             };
}

# pragma addressJSONTransformer

- (NSValueTransformer *)addressJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *addressDict) {
        return [MTLJSONAdapter  modelOfClass:CLAddress.class
                                fromJSONDictionary:addressDict
                                error:nil];
    } reverseBlock:^(CLAddress *address) {
        return [MTLJSONAdapter JSONDictionaryFromModel:address];
    }];
}


# pragma urlSchemeJSONTransformer

+ (NSValueTransformer *)urlSchemeJSONTransformer {
    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
    // you can write your own transformers
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


# pragma imageJSONTransformer

- (NSValueTransformer *)eventImageJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *imageDict) {
        return [MTLJSONAdapter  modelOfClass:CLImage.class
                          fromJSONDictionary:imageDict
                                       error:nil];
    } reverseBlock:^(CLImage *image) {
        return [MTLJSONAdapter JSONDictionaryFromModel:image];
    }];
}


# pragma participantsJSONTransformer

- (NSValueTransformer *)participantsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CLParticipant.class];
}


# pragma timeZoneJSONTransformer

- (NSValueTransformer *)timeZoneJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *timeZoneDict) {
        return [MTLJSONAdapter  modelOfClass:CLTimeZone.class
                          fromJSONDictionary:timeZoneDict
                                       error:nil];
    } reverseBlock:^(CLTimeZone *timeZone) {
        return [MTLJSONAdapter JSONDictionaryFromModel:timeZone];
    }];
}


# pragma seriesJSONTransformer

- (NSValueTransformer *)seriesJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *seriesDict) {
        return [MTLJSONAdapter  modelOfClass:CLSeries.class
                          fromJSONDictionary:seriesDict
                                       error:nil];
    } reverseBlock:^(CLSeries *series) {
        return [MTLJSONAdapter JSONDictionaryFromModel:series];
    }];
}


# pragma coodinatorJSONTransformer

- (NSValueTransformer *)coordinatorJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *coorDict) {
        return [MTLJSONAdapter  modelOfClass:CLCoordinator.class
                          fromJSONDictionary:coorDict
                                       error:nil];
    } reverseBlock:^(CLCoordinator *coor) {
        return [MTLJSONAdapter JSONDictionaryFromModel:coor];
    }];
}


@end
