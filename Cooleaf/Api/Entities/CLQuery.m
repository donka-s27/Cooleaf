//
//  CLQuery.m
//  Cooleaf
//
//  Created by Haider Khan on 9/14/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLQuery.h"
#import "CLTag.h"

@implementation CLQuery

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"queryId": @"id",
             @"queryName": @"name",
             @"content": @"content",
             @"type": @"type",
             @"tags": @"tags",
             @"itemPath": @"url",
             @"imagePath": @"image_url"
             };
}

# pragma mark - tagsJSONTransformer

- (NSValueTransformer *)tagsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CLTag.class];
}

@end
