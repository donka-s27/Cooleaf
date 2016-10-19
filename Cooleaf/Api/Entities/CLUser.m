//
//  NPUser.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLUser.h"

@implementation CLUser

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"id",
             @"userName": @"name",
             @"userEmail": @"email",
             @"interests": @"categories",
             @"role": @"role",
             @"rewardPoints": @"reward_points",
             @"profile": @"profile"
             };
}

# pragma interestsJSONTransformer

- (NSValueTransformer *)interestsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CLInterest.class];
}

# pragma roleJSONTransformer

- (NSValueTransformer *)roleJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *roleDict) {
        return [MTLJSONAdapter  modelOfClass:CLRole.class
                                fromJSONDictionary:roleDict
                                error:nil];
    } reverseBlock:^(CLRole *role) {
        return [MTLJSONAdapter JSONDictionaryFromModel:role];
    }];
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
