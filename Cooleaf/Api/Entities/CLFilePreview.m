//
//  CLFilePreview.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLFilePreview.h"

@implementation CLFilePreview

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fileCache": @"file_cache",
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

@end
