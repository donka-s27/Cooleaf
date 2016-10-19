//
//  NPRole.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLRole.h"

@implementation CLRole

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"isActive": @"active",
             @"rights": @"rights",
             @"organization": @"organization",
             @"branch": @"branch",
             @"department": @"department",
             @"structureTags": @"structure_tags",
             @"structures": @"structures"
             };
}

# pragma organizationJSONTransformer

- (NSValueTransformer *)organizationJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *organizationDict) {
        return [MTLJSONAdapter  modelOfClass:CLOrganization.class
                                fromJSONDictionary:organizationDict
                                error:nil];
    } reverseBlock:^(CLOrganization *organization) {
        return [MTLJSONAdapter JSONDictionaryFromModel:organization];
    }];
}

# pragma branchJSONTransformer

- (NSValueTransformer *)branchJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *branchDict) {
        return [MTLJSONAdapter  modelOfClass:CLBranch.class
                                fromJSONDictionary:branchDict
                                error:nil];
    } reverseBlock:^(CLBranch *branch) {
        return [MTLJSONAdapter JSONDictionaryFromModel:branch];
    }];
}

# pragma departmentJSONTransformer

- (NSValueTransformer *)departmentJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *deptDict) {
        return [MTLJSONAdapter  modelOfClass:CLDepartment.class
                                fromJSONDictionary:deptDict
                                error:nil];
    } reverseBlock:^(CLDepartment *dept) {
        return [MTLJSONAdapter JSONDictionaryFromModel:dept];
    }];
}

@end
