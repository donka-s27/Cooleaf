//
//  CLCategory.m
//  Cooleaf
//
//  Created by Haider Khan on 9/22/15.
//  Copyright © 2015 Nova Project. All rights reserved.
//

#import "CLCategory.h"

@implementation CLCategory

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tagId": @"id",
             @"tagName": @"name",
             @"organizationId": @"organization_id",
             @"type": @"type",
             @"createdAt": @"created_at",
             @"updatedAt": @"updated_at",
             @"active": @"active",
             @"parentId": @"parent_id",
             @"parentType": @"parent_type",
             @"picture": @"picture",
             @"slug": @"slug"
             };
}

# pragma mark - pictureJSONTransformer

- (NSValueTransformer *)pictureJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *pictureDict) {
        return [MTLJSONAdapter  modelOfClass:CLPicture.class
                          fromJSONDictionary:pictureDict
                                       error:nil];
    } reverseBlock:^(CLPicture *picture) {
        return [MTLJSONAdapter JSONDictionaryFromModel:picture];
    }];
}

@end
