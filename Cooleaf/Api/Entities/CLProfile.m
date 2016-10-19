//
//  NPProfile.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLProfile.h"

@implementation CLProfile

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"gender": @"gender",
             @"picture": @"picture",
             @"settings": @"settings"
             };
}


# pragma pictureJSONTransformer

- (NSValueTransformer *)pictureJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *picDict) {
        return [MTLJSONAdapter  modelOfClass:CLPicture.class
                                fromJSONDictionary:picDict
                                error:nil];
    } reverseBlock:^(CLPicture *picture) {
        return [MTLJSONAdapter JSONDictionaryFromModel:picture];
    }];
}


# pragma settingsJSONTransformer

- (NSValueTransformer *)settingsJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *settingsDict) {
        return [MTLJSONAdapter  modelOfClass:CLSettings.class
                                fromJSONDictionary:settingsDict
                                error:nil];
    } reverseBlock:^(CLSettings *settings) {
        return [MTLJSONAdapter JSONDictionaryFromModel:settings];
    }];
}

@end
