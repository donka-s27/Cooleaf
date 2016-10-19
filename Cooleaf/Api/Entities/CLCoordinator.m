//
//  CLCoordinator.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLCoordinator.h"

@implementation CLCoordinator

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"coordinatorId": @"id",
             @"isForeign": @"foreign",
             @"coordinatorName": @"name",
             @"coordinatorEmail": @"email",
             @"coordinatorProfile": @"profile"
             };
}

# pragma profileJSONTransformer

- (NSValueTransformer *)profileJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *profileDict) {
        return [MTLJSONAdapter  modelOfClass:CLProfile.class
                          fromJSONDictionary:profileDict
                                       error:nil];
    } reverseBlock:^(CLProfile *profile) {
        return [MTLJSONAdapter JSONDictionaryFromModel:profile];
    }];
}

@end
