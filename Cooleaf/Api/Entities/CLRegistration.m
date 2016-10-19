//
//  CLRegistration.m
//  Cooleaf
//
//  Created by Haider Khan on 9/29/15.
//  Copyright © 2015 Nova Project. All rights reserved.
//

#import "CLRegistration.h"
#import "CLTag.h"
#import "CLParentTag.h"

@implementation CLRegistration

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"email": @"email",
             @"organizationId": @"organization_id",
             @"organizationSubdomain": @"organization_subdomain",
             @"token": @"token",
             @"structures": @"structures",
             @"allStructures": @"all_structures",
             @"chosenStructureIds": @"chosen_structure_ids"
             };
}

# pragma mark - structuresJSONTransformer

- (NSValueTransformer *)structuresJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CLTag class]];
}

# pragma mark - allStructuresJSONTransformer

- (NSValueTransformer *)allStructuresJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CLParentTag class]];
}

@end


