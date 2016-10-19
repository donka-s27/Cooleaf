//
//  NPOrganization.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLOrganization.h"
#import "CLParentTag.h"

@implementation CLOrganization

# pragma mark - MTLJSONSeriliazation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"organizationId": @"id",
             @"organizationName": @"name",
             @"organizationSubdomain": @"subdomain",
             @"organizationPicture": @"logo",
             @"structures": @"structures"
             };
}

# pragma mark - pictureJSONTransformer

- (NSValueTransformer *)organizationPictureJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *pictureDict) {
        return [MTLJSONAdapter  modelOfClass:CLPicture.class
                                fromJSONDictionary:pictureDict
                                error:nil];
    } reverseBlock:^(CLPicture *picture) {
        return [MTLJSONAdapter  JSONDictionaryFromModel:picture];
    }];
}

# pragma mark - structuresJSONTransformer

- (NSValueTransformer *)structuresJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CLParentTag.class];
}

@end
