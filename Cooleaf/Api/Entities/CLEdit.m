//
//  CLEdit.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLEdit.h"

@implementation CLEdit

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categoryIds": @"category_ids",
             @"email": @"email",
             @"fileCache": @"file_cache",
             @"editId": @"id",
             @"name": @"name",
             @"profile": @"profile",
             @"removePicture": @"removed_picture",
             @"rewardPoints": @"reward_points",
             @"role": @"role"
             };
}


# pragma categoryIdJSONTransformer

- (NSValueTransformer *)interestsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:NSNumber.class];
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

@end
