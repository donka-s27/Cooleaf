//
//  NPVersions.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLVersions.h"

@implementation CLVersions

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"thumbUrl": @"thumb",
             @"iconUrl": @"icon",
             @"smallUrl": @"small",
             @"mediumUrl": @"medium",
             @"largeUrl": @"large",
             @"bigUrl": @"big",
             @"mainUrl": @"main",
             @"coverUrl": @"cover"
             };
}


# pragma urlSchemeJSONTransformer

+ (NSValueTransformer *)urlSchemeJSONTransformer {
    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
    // you can write your own transformers
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
