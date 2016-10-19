//
//  CLInterest.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLInterest.h"

@implementation CLInterest

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"interestId": @"id",
             @"name": @"name",
             @"type": @"type",
             @"active": @"active",
             @"parentType": @"parent_type",
             @"image": @"image",
             @"userCount": @"users_count",
             @"member": @"member"
             };
}

# pragma mark - imageJSONTransformer

- (NSValueTransformer *)imageJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *imageDict) {
        return [MTLJSONAdapter  modelOfClass:CLImage.class
                                fromJSONDictionary:imageDict
                                error:nil];
    } reverseBlock:^(CLImage *image) {
        return [MTLJSONAdapter JSONDictionaryFromModel:image];
    }];
}

@end
