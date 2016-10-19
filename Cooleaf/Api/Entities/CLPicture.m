//
//  NPPicture.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLPicture.h"

@implementation CLPicture

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"originalUrl": @"original",
             @"versions": @"versions"
             };
}


# pragma urlSchemeJSONTransformer

+ (NSValueTransformer *)urlSchemeJSONTransformer {
    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
    // you can write your own transformers
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


# pragma versionsJSONTransformer

- (NSValueTransformer *)versionsJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *versionsDict) {
        return [MTLJSONAdapter  modelOfClass:CLVersions.class
                                fromJSONDictionary:versionsDict
                                error:nil];
    } reverseBlock:^(CLVersions *versions) {
        return [MTLJSONAdapter JSONDictionaryFromModel:versions];
    }];
}


@end
