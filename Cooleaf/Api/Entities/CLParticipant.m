//
//  CLParticipant.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLParticipant.h"
#import "CLRole.h"
#import "CLCategory.h"

@implementation CLParticipant

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"participantId": @"id",
             @"name": @"name",
             @"email": @"email",
             @"role": @"role",
             @"profile": @"profile",
             @"categories": @"categories",
             @"selected": @"selected",
             @"eventId": @"event_id",
             @"checkedOutEvents": [NSNull null] // Ignore this property
             };
}

# pragma mark - profileJSONTransformer

- (NSValueTransformer *)roleJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *roleDict) {
        return [MTLJSONAdapter  modelOfClass:CLRole.class
                          fromJSONDictionary:roleDict
                                       error:nil];
    } reverseBlock:^(CLRole *role) {
        return [MTLJSONAdapter JSONDictionaryFromModel:role];
    }];
}

# pragma mark - profileJSONTransformer

- (NSValueTransformer *)profileJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *profileDict) {
        return [MTLJSONAdapter  modelOfClass:CLProfile.class
                          fromJSONDictionary:profileDict
                                       error:nil];
    } reverseBlock:^(CLProfile *profile) {
        return [MTLJSONAdapter JSONDictionaryFromModel:profile];
    }];
}

# pragma mark - categoriesJSONTransformer

- (NSValueTransformer *)categoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CLCategory.class];
}

# pragma mark - urlSchemeJSONTransformer

+ (NSValueTransformer *)urlSchemeJSONTransformer {
    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
    // you can write your own transformers
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
