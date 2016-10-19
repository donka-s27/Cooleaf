//
//  NPParentTag.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLParentTag.h"

@implementation CLParentTag

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"parentTagId": @"id",
             @"parentTagName": @"name",
             @"tags": @"tags",
             @"isRequired": @"required",
             @"isPrimary": @"primary"
             };
}

# pragma tagsJSONTransformer

+ (NSValueTransformer *)tagsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CLTag.class];
}

@end


